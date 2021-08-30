ARG NEXTCLOUD_BASE_IMAGE=nextcloud:19.0-apache
FROM ${NEXTCLOUD_BASE_IMAGE}

RUN apt update && apt install ssl-cert
RUN ln -s /etc/apache2/mods-available/socache_shmcb.load /etc/apache2/mods-enabled/
RUN ln -s /etc/apache2/mods-available/ssl.conf /etc/apache2/mods-enabled/
RUN ln -s /etc/apache2/mods-available/ssl.load /etc/apache2/mods-enabled/
RUN mkdir -p /var/www/html/data/
RUN chown -R www-data:root /var/www/html/
RUN touch /var/www/html/data/nextcloud.log 
RUN chown www-data:www-data /var/www/html/data/nextcloud.log
RUN ln -s /dev/stdout /var/www/html/data/nextcloud.log 
COPY --chown=www-data:www-data ./gss_config.sh /
COPY --chown=www-data:www-data ./mail_config.sh /
COPY --chown=root:root ./000-default.conf /etc/apache2/sites-available/
COPY --chown=root:root ./extended_entrypoint.sh /
ENTRYPOINT ["/extended_entrypoint.sh"]
CMD ["apache2-foreground"]
