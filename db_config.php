<?php
// Database configuration
define('DB_HOST', 'localhost');        // Usually 'localhost' or '127.0.0.1'
define('DB_PORT', '5432');            // Default PostgreSQL port
define('DB_NAME', 'lennufirma_db');      // Your database name
define('DB_USER', 'lennufirma_user');          // Your PostgreSQL username <<< CHANGE THIS
define('DB_PASS', 'user');      // Your PostgreSQL password <<< CHANGE THIS
define('DB_SCHEMA', 'lennufirma');    // The schema name

// Optional: Error reporting settings for development
// In production, you might want to log errors instead of displaying them
error_reporting(E_ALL);
ini_set('display_errors', 1);
?>