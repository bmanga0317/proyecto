<?php
session_start();

//Include Google client library 
include_once 'src/Google_Client.php';
include_once 'src/contrib/Google_Oauth2Service.php';

/*
 * Configuration and setup Google API
 */
$clientId = '525237952140-6favsas3qintkj7frjap7vtbift4rnle.apps.googleusercontent.com'; //Google client ID
$clientSecret = 'm6qFM6D8gqRVnPGQQ-MJjhh0'; //Google client secret
$redirectURL = 'http://localhost/login/'; //Callback URL

//Call Google API
$gClient = new Google_Client();
$gClient->setApplicationName('login to CodexWorld.com');
$gClient->setClientId($clientId);
$gClient->setClientSecret($clientSecret);
$gClient->setRedirectUri($redirectURL);

$google_oauthV2 = new Google_Oauth2Service($gClient);
?>
