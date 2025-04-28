<?php
require_once __DIR__ . '/db_config.php';

/**
 * Establishes a PDO database connection.
 * Sets the search_path to the specified schema.
 *
 * @return PDO|null Returns a PDO connection object on success, null on failure.
 */
function getDbConnection(): ?PDO
{
    $dsn = "pgsql:host=" . DB_HOST . ";port=" . DB_PORT . ";dbname=" . DB_NAME;
    $options = [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION, // Throw exceptions on errors
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,       // Fetch associative arrays
        PDO::ATTR_EMULATE_PREPARES   => false,                  // Use native prepared statements
    ];

    try {
        $pdo = new PDO($dsn, DB_USER, DB_PASS, $options);
        // Set the schema search path for this connection
        $pdo->exec("SET search_path TO " . DB_SCHEMA . ", public;");
        return $pdo;
    } catch (PDOException $e) {
        // In a real app, log this error instead of echoing
        echo "Connection failed: " . $e->getMessage();
        return null;
    }
}

/**
 * Helper function to fetch data needed for dropdowns.
 *
 * @param PDO $pdo The PDO connection object.
 * @param string $functionName The name of the PostgreSQL function to call (e.g., 'fn_lennujaam_read_all').
 * @param string $valueField The column name for the option value.
 * @param string $textField The column name for the option text.
 * @return array An associative array suitable for generating dropdown options.
 */

?>