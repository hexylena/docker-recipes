<?php

// Used to failover from env variables nicely
function arr_get($array, $key, $default = null){
    return isset($array[$key]) ? $array[$key] : $default;
}


$databases['default']['default'] = array(
  'driver' => 'pgsql',
  'database' => 'postgres',
  'username' => 'postgres',
  'password' => 'password',
  'host' => arr_get($_ENV, "DB_PORT_5432_TCP_ADDR", "localhost"),
  'prefix' => '',
);

$update_free_access = FALSE;
$drupal_hash_salt = arr_get(
    $_ENV, 
    "DRUPAL_SALT", 
    substr(
        str_shuffle("0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"), 
        0, 
        32
    )
);

/**
 * Base URL (optional).
 *
 * If Drupal is generating incorrect URLs on your site, which could
 * be in HTML headers (links to CSS and JS files) or visible links on pages
 * (such as in menus), uncomment the Base URL statement below (remove the
 * leading hash sign) and fill in the absolute URL to your Drupal installation.
 *
 * You might also want to force users to use a given domain.
 * See the .htaccess file for more information.
 *
 * Examples:
 *   $base_url = 'http://www.example.com';
 *   $base_url = 'http://www.example.com:8888';
 *   $base_url = 'http://www.example.com/drupal';
 *   $base_url = 'https://www.example.com:8888/drupal';
 *
 * It is not allowed to have a trailing slash; Drupal will add it
 * for you.
 */
# $base_url = 'http://www.example.com';  // NO trailing slash!

ini_set('session.gc_probability', 1);
ini_set('session.gc_divisor', 100);
ini_set('session.gc_maxlifetime', 200000);
ini_set('session.cookie_lifetime', 2000000);

$conf['site_name'] = arr_get($_ENV, "DRUPAL_SITE_NAME", 'My Drupal site');
$conf['theme_default'] = arr_get($_ENV, "DRUPAL_DEFAULT_THEME", 'garland');
# $conf['anonymous'] = 'Visitor';
# $conf['maintenance_theme'] = 'bartik';
# $conf['reverse_proxy'] = TRUE;
# $conf['reverse_proxy_addresses'] = array('a.b.c.d', ...);
# $conf['reverse_proxy_header'] = 'HTTP_X_CLUSTER_CLIENT_IP';
$conf['allow_authorize_operations'] = TRUE;
