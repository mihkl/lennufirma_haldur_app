<?php
require_once __DIR__ . '/db_config.php';

/**
 * Logs an error message to a file.
 *
 * @param string $message The error message to log.
 */
function log_error(string $message): void
{
    $logFilePath = __DIR__ . '/error.log';
    $timestamp = date('Y-m-d H:i:s');
    $logMessage = "[{$timestamp}] " . $message . "\n";
    file_put_contents($logFilePath, $logMessage, FILE_APPEND | LOCK_EX);
    echo nl2br(htmlspecialchars($logMessage));
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