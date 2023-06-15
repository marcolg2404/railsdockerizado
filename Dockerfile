# Usamos la imagen oficial de ruby
ARG RUBY_VERSION=2.7.4
FROM ruby:$RUBY_VERSION

# Configuramos la carpeta de trabajo
WORKDIR /app

# Instalamos las dependencias
RUN apt-get update -qq && \
  apt-get install -y build-essential libvips bash bash-completion libffi-dev tzdata postgresql nodejs npm yarn && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man

# Instalamos las gemas
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copiamos el código de la aplicación
COPY . .

RUN ["chmod", "+x", "./bin/docker-entrypoint"]

# Entrypoint prepares the database.
ENTRYPOINT ["./bin/docker-entrypoint"]

# Exponemos el puerto 3000
EXPOSE 3000

# Corremos el comando para iniciar rails
CMD ["rails", "server", "-b", "0.0.0.0"]
