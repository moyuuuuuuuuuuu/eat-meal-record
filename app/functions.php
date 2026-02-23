<?php
/**
 * Here is your custom functions.
 */
if (!function_exists('source')) {
    function source(?string $uri): ?string
    {
        if (!$uri) return null;
        return getenv('SOURCE_DOMAIN') . $uri;
    }
}
