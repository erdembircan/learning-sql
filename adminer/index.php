<?php
use Adminer\Adminer;
use function Adminer\nonce;

$autoDb = (string) getenv('MYSQL_DATABASE');
if ($autoDb !== '' && isset($_GET['username']) && !isset($_GET['db']) && !isset($_GET['server'])) {
    $server = getenv('ADMINER_DEFAULT_SERVER') ?: 'mysql';
    $user = getenv('ADMINER_AUTO_LOGIN_USER') ?: 'root';
    header('Location: ?' . http_build_query([
        'server'   => $server,
        'username' => $user,
        'db'       => $autoDb,
    ]));
    exit;
}

function adminer_object() {
    class AdminerAutoLogin extends Adminer {
        function credentials() {
            return [
                getenv('ADMINER_DEFAULT_SERVER') ?: 'mysql',
                getenv('ADMINER_AUTO_LOGIN_USER') ?: 'root',
                (string) getenv('MYSQL_ROOT_PASSWORD'),
            ];
        }

        function database() {
            return (string) getenv('MYSQL_DATABASE');
        }

        function login($login, $password) {
            return true;
        }

        function loginForm() {
            parent::loginForm();
            $password = json_encode((string) getenv('MYSQL_ROOT_PASSWORD'));
            echo "<script" . nonce() . ">
                document.querySelector('input[name=\"auth[password]\"]').value = {$password};
                document.forms[0].submit();
            </script>";
        }

        function head($Mb = null) {
            if (isset($_GET['sql'])) {
                echo "<script" . nonce() . ">
                    document.addEventListener('DOMContentLoaded', function() {
                        var cb = document.querySelector('input[name=\"error_stops\"]');
                        if (cb && !cb.checked) cb.checked = true;
                    });
                </script>\n";
            }
            return true;
        }
    }
    return new AdminerAutoLogin;
}

include './adminer.php';
