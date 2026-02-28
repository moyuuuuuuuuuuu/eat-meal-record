<?php
/**
 * Here is your custom functions.
 */

if (!function_exists('source')) {
    function source(?string $uri): ?string
    {
        if (!$uri) return null;
        if (str_starts_with($uri, 'http://') || str_starts_with($uri, 'https://')) {
            return $uri;
        }
        return getenv('SOURCE_DOMAIN') . $uri;
    }
}
