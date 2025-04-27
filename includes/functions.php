<?php
require_once __DIR__ . '/../config/db_config.php';

/**
 * Logs an error message to a file.
 *
 * @param string $message The error message to log.
 */
function log_error(string $message): void
{
    $logFilePath = __DIR__ . '/../logs/error.log';
    $timestamp = date('Y-m-d H:i:s');
    $logMessage = "[{$timestamp}] " . $message . "\n";
    file_put_contents($logFilePath, $logMessage, FILE_APPEND | LOCK_EX);
}

/**
 * Redirects to a given URL, optionally passing messages and old input.
 *
 * @param string $url The URL to redirect to.
 * @param array|null $message ['type' => 'success|error', 'text' => '...']
 * @param array|null $errors Validation errors ['field' => 'message', ...]
 * @param array|null $oldInput Submitted form data to repopulate form.
 */
function redirect(string $url, ?array $message = null, ?array $errors = null, ?array $oldInput = null): void
{
    if ($message) {
        $_SESSION['message'] = $message;
    }
    if ($errors) {
        $_SESSION['errors'] = $errors;
    }
    if ($oldInput) {
        $_SESSION['old_input'] = array_map('htmlspecialchars', $oldInput);
    }
    header("Location: " . $url);
    exit();
}

/**
 * Fetches data for dropdowns from a table or SQL function.
 *
 * @param PDO $pdo Database connection.
 * @param string $source Table name or function name (e.g., 'fn_lennujaam_read_all').
 * @param string $valueField Field to use as option value.
 * @param string|null $labelField Field to use as option label (null to use valueField).
 * @param callable|null $labelCallback Optional callback to format label from row.
 * @return array Associative array [value => label].
 */
function fetchDropdownData(PDO $pdo, string $source, string $valueField, ?string $labelField = null, ?callable $labelCallback = null): array
{
    $data = [];
    try {
        // Check if source is a function (starts with 'fn_')
        if (strpos($source, 'fn_') === 0) {
            $stmt = $pdo->prepare("SELECT * FROM lennufirma.$source()");
            $stmt->execute();
        } else {
            // Assume it's a table name
            $stmt = $pdo->query("SELECT $valueField" . ($labelField ? ", $labelField" : "") . " FROM lennufirma.$source ORDER BY " . ($labelField ?: $valueField));
        }

        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            $value = $row[$valueField];
            $label = $labelCallback ? $labelCallback($row) : ($labelField ? $row[$labelField] : $value);
            $data[$value] = $label;
        }
    } catch (PDOException $e) {
        log_error("Failed to fetch dropdown data from $source: " . $e->getMessage());
    }
    return $data;
}

/**
 * Basic validation function.
 *
 * @param array $data The data to validate (e.g., $_POST).
 * @param array $rules Validation rules ['field' => 'rule1|rule2', ...].
 * @return array Associative array of errors ['field' => 'error message', ...]. Empty if valid.
 */
function validate(array $data, array $rules): array
{
    $errors = [];
    foreach ($rules as $field => $ruleString) {
        $value = $data[$field] ?? null;
        $ruleList = explode('|', $ruleString);

        foreach ($ruleList as $rule) {
            $param = null;
            if (strpos($rule, ':') !== false) {
                list($rule, $param) = explode(':', $rule, 2);
            }

            switch ($rule) {
                case 'required':
                    if (empty($value) && $value !== '0') {
                        $errors[$field] = ucfirst(str_replace('_', ' ', $field)) . " is required.";
                    }
                    break;
                case 'email':
                    if (!empty($value) && !filter_var($value, FILTER_VALIDATE_EMAIL)) {
                        $errors[$field] = ucfirst(str_replace('_', ' ', $field)) . " must be a valid email address.";
                    }
                    break;
                case 'numeric':
                    if (!empty($value) && !is_numeric($value)) {
                        $errors[$field] = ucfirst(str_replace('_', ' ', $field)) . " must be a number.";
                    }
                    break;
                case 'integer':
                    if (!empty($value) && !filter_var($value, FILTER_VALIDATE_INT)) {
                        $errors[$field] = ucfirst(str_replace('_', ' ', $field)) . " must be an integer.";
                    }
                    break;
                case 'positive':
                    if (!empty($value) && (!is_numeric($value) || floatval($value) <= 0)) {
                        $errors[$field] = ucfirst(str_replace('_', ' ', $field)) . " must be a positive number.";
                    }
                    break;
                case 'datetime':
                    if (!empty($value)) {
                        try {
                            $dt = new DateTime($value);
                        } catch (Exception $e) {
                            $errors[$field] = ucfirst(str_replace('_', ' ', $field)) . " must be a valid date and time.";
                        }
                    }
                    break;
                case 'date':
                    if (!empty($value)) {
                        try {
                            $dt = DateTime::createFromFormat('Y-m-d', $value);
                            if (!$dt || $dt->format('Y-m-d') !== $value) {
                                throw new Exception();
                            }
                        } catch (Exception $e) {
                            $errors[$field] = ucfirst(str_replace('_', ' ', $field)) . " must be a valid date (YYYY-MM-DD).";
                        }
                    }
                    break;
                case 'min':
                    if (!empty($value) && is_numeric($value) && floatval($value) < floatval($param)) {
                        $errors[$field] = ucfirst(str_replace('_', ' ', $field)) . " must be at least {$param}.";
                    } elseif (!empty($value) && !is_numeric($value) && strlen($value) < intval($param)) {
                        $errors[$field] = ucfirst(str_replace('_', ' ', $field)) . " must be at least {$param} characters long.";
                    }
                    break;
                case 'max':
                    if (!empty($value) && !is_numeric($value) && strlen($value) > intval($param)) {
                        $errors[$field] = ucfirst(str_replace('_', ' ', $field)) . " must not exceed {$param} characters.";
                    }
                    break;
                case 'alpha_num':
                    if (!empty($value) && !ctype_alnum($value)) {
                        $errors[$field] = ucfirst(str_replace('_', ' ', $field)) . " may only contain letters and numbers.";
                    }
                    break;
                case 'alpha_space':
                    if (!empty($value) && !preg_match('/^[A-Za-z\s]+$/u', $value)) {
                        $errors[$field] = ucfirst(str_replace('_', ' ', $field)) . " may only contain letters and spaces.";
                    }
                    break;
                case 'in':
                    if (!empty($value) && $param) {
                        $allowed = explode(',', $param);
                        if (!in_array($value, $allowed)) {
                            $errors[$field] = ucfirst(str_replace('_', ' ', $field)) . " contains an invalid option.";
                        }
                    }
                    break;
                case 'latitude':
                    if (!empty($value) && (!is_numeric($value) || $value < -90 || $value > 90)) {
                        $errors[$field] = ucfirst(str_replace('_', ' ', $field)) . " must be a valid latitude (-90 to 90).";
                    }
                    break;
                case 'longitude':
                    if (!empty($value) && (!is_numeric($value) || $value < -180 || $value > 180)) {
                        $errors[$field] = ucfirst(str_replace('_', ' ', $field)) . " must be a valid longitude (-180 to 180).";
                    }
                    break;
                case 'flight_code':
                    if (!empty($value) && !preg_match('/^[A-Z0-9]{2,10}$/', $value)) {
                        $errors[$field] = ucfirst(str_replace('_', ' ', $field)) . " must be a 2-10 character code (letters and numbers).";
                    }
                    break;
            }
            if (isset($errors[$field])) {
                break;
            }
        }
    }
    return $errors;
}