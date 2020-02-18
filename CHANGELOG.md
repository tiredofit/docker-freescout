## 1.6.12 2020-02-18 <dave at tiredofit dot ca>

   ### Added
      - Freescout 1.4.11


## 1.6.11 2020-02-16 <dave at tiredofit dot ca>

   ### Added
      - Freescout 1.4.10


## 1.6.10 2020-02-09 <dave at tiredofit dot ca>

   ### Added
      - Freescout 1.4.9


## 1.6.9 2020-02-02 <dave at tiredofit dot ca>

   ### Added
      - Freescout 1.4.8


## 1.6.8 2020-01-29 <dave at tiredofit dot ca>

   ### Added
      - Freescout 1.6.8


## 1.6.7 2020-01-25 <dave at tiredofit dot ca>

   ### Added
      - Freescout 1.4.6


## 1.6.6 2020-01-24 <dave at tiredofit dot ca>

   ### Added
      - Freescout 1.4.4


## 1.6.5 2020-01-19 <dave at tiredofit dot ca>

   ### Added
      - Freescout 1.4.3


## 1.6.4 2020-01-17 <dave at tiredofit dot ca>

   ### Added
      - Freescout 1.4.2


## 1.6.3 2020-01-14 <dave at tiredofit dot ca>

   ### Added
      - Freescout 1.4.1


## 1.6.2 2020-01-07 <dave at tiredofit dot ca>

   ### Added
      - Freescout 1.4.0

## 1.6.1 2020-01-02 <dave at tiredofit dot ca>

   ### Changed
      - Additional changes to support new tiredofit/alpine base image


## 1.6.0 2019-12-29 <dave at tiredofit dot ca>

   ### Added
      - Update to support new tiredofit/alpine base image


## 1.5.8 2019-12-28 <dave at tiredofit dot ca>

   ### Added
      - FreeScout 1.3.19


## 1.5.7 2019-12-22 <dave at tiredofit dot ca>

   ### Added
      - Freescout 1.3.18


## 1.5.6 2019-12-21 <dave at tiredofit dot ca>

   ### Added
      - Freescout 1.3.17


## 1.5.5 2019-12-18 <dave at tiredofit dot ca>

   ### Added
      - Freescout 1.3.16


## 1.5.4 2019-12-18 <dave at tiredofit dot ca>

   ### Changed
      - Dynamically set Nginx User and Group permissions across project


## 1.5.3 2019-12-17 <dave at tiredofit dot ca>

   ### Added
      - Freescout 1.3.15


## 1.5.2 2019-12-17 <dave at tiredofit dot ca>

   ### Changed
      - Cleanup Dockerfile


## 1.5.1 2019-12-15 <dave at tiredofit dot ca>

   ### Changed
      - Bugfixes to initialization script


## 1.5.0 2019-12-13 <dave at tiredofit dot ca>

   ### Added
      - Add `APPLICATION_NAME` to support changing name from Freescout to something custom


## 1.4.4 2019-12-12 <dave at tiredofit dot ca>

   ### Changed
      - Final tweak to running database migrations on startup


## 1.4.3 2019-12-12 <dave at tiredofit dot ca>

   ### Changed
      - Change in the way that DB Migrations are done. Do them every time to avoid any uncaught module installations


## 1.4.2 2019-12-11 <dave at tiredofit dot ca>

   ### Added
      - Add alias for running artisan - Type `artisan <arguments>` inside of container to run commands as webserver user


## 1.4.1 2019-12-11 <dave at tiredofit dot ca>

   ### Changed
      - Quiet down Module installation output


## 1.4.0 2019-12-11 <dave at tiredofit dot ca>

   ### Added
      - Add execution of custom scripts upon container startup (map /assets/custom-scripts)

   ### Changed
      - Fixed error where Module installation would hang


## 1.3.0 2019-12-10 <dave at tiredofit dot ca>

   ### Added
      - Refinements to Persistent Storage specifically Modules and Configuration Files
   
   ### Changed
      - Considerable cleanup related to storage
      - Automatically install Modules and clear cache routines
      - Much easier to survive container restarts
      - Fix related to auto upgrade routines


## 1.2.0 2019-12-09 <dave at tiredofit dot ca>

   ### Added
      - Refactor to support new tiredofit/nginx-php-fpm base image
      - Freescout 1.3.14


## 1.1.2 2019-11-25 <dave at tiredofit dot ca>

   ### Added
      - Freescout 1.3.12


## 1.1.1 2019-11-20 <dave at tiredofit dot ca>

   ### Added
      - Make modules persistent via new functionality introduced in 1.1.0


## 1.1.0 2019-11-20 <dave at tiredofit dot ca>

   ### Added
      - Added persistent storage for sessions, cache, and vars - Mount /data as a volume to benefit

   ### Changed
      - Updated docker-compose examples


## 1.0.4 2019-11-17 <dave at tiredofit dot ca>

   ### Changed
      - Update to Freescout 1.3.11


## 1.0.3 2019-11-11 <dave at tiredofit dot ca>

* Freescout 1.3.10

## 1.0.2 2019-10-23 <dave at tiredofit dot ca>

* Freescout 1.3.8

## 1.0.1 2019-09-10 <dave at tiredofit dot ca>

* Freescout 1.3.6

## 1.0 2019-08-08 <dave at tiredofit dot ca> w/ help from <briangilbert@github>

* Freescout 1.3.5
* Ability to Self Update
* Auto upgrade from Image version to image version
* Ability to add custom modules
* Ability to have access to custom source (this should allow Auto Updating to work without having to always update the image)
* Moved back to tiredofit/nginx-php-fpm base image to make development and upkeep easier
* PHP 7.3

## 0.11 2019-07-31 <dave at tiredofit dot ca>

* Freescout 1.3.3

## 0.10 2019-07-07 <dave at tiredofit dot ca>

* Freescout 1.2.4

## 0.9 2019-04-27 <dave at tiredofit dot ca>

* Freescout 1.1.7

## 0.8 2019-04-08 <dave at tiredofit dot ca>

* Switch to Alpine Edge
* Use gnuiconv from community instead of testing

## 0.7 2019-01-03 <dave at tiredofit dot ca>

* Freescout 1.1.6

## 0.6 2018-12-21 <dave at tiredofit dot ca>

* Freescout 1.1.3

## 0.5 2018-12-10 <dave at tiredofit dot ca>

* Freescout 1.1.1

## 0.4 2018-11-27 <dave at tiredofit dot ca>

* Freescout 1.0.7

## 0.3 2018-11-06 <dave at tiredofit dot ca>

* Rebuild Image from Alpine 3.8 Base omitting previous usage of tiredofit/nginx-php-fpm
* Fix for Iconv PHP Imap Errors (really)
* Alter location for freescout logs
* Logrotate for Freescout Fetch Logs

## 0.2 2018-11-04 <dave at tiredofit dot ca>

* Add gnu-libiconv to resolve IMAP errors

## 0.1 2018-11-03 <dave at tiredofit dot ca>

* Initial Release
* Alpine 3.8
* PHP 7.2
* Freescout 1.0.0


