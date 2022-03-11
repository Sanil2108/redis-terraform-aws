FROM redis:6.2

WORKDIR /redis-workdir

# Installing OS level dependencies
RUN apt-get update
RUN apt-get install -y wget
RUN apt-get install -y gettext-base

# Downloading redis default config
RUN wget https://raw.githubusercontent.com/redis/redis/6.2/redis.conf
RUN mv redis.conf redis.default.conf

COPY . .

CMD envsubst < redis.conf > updated_redis.conf && redis-server ./updated_redis.conf