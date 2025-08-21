<?php
/**
 * Here is your custom functions.
 */
function getImageUrl(string $image): string
{
    if (!$image) return '';
    if (str_contains($image, 'http') || str_contains($image, 'https')) {
        return $image;
    }
    //获取当前域名并拼接
    return request()->domain() . $image;
}
