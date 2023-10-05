# Utilisez une image de base appropriée pour WordPress
FROM wordpress:latest

# Spécifiez les valeurs pour la base de données à l'aide de l'instruction ENV
ENV WORDPRESS_DB_USER=wordpress
ENV WORDPRESS_DB_PASSWORD=ilovedevops
ENV WORDPRESS_DB_NAME=wordpress
ENV WORDPRESS_DB_HOST=35.224.159.165

# Commande pour démarrer le serveur web WordPress (par défaut)
CMD ["apache2-foreground"]