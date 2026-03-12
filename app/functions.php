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
        $uri    = ltrim($uri, '/');
        $domain = rtrim(getenv('SOURCE_DOMAIN'), '/');
        return $domain . '/' . $uri;
    }
}
