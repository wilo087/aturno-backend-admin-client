FROM node:lts-alpine AS build-stage
WORKDIR /app
COPY ./package*.json ./

RUN curl -o- -L https://yarnpkg.com/install.sh | bash
RUN $HOME/.yarn/bin/yarn install


# Install dependencies
RUN yarn install

COPY . .

# Add jest global
RUN yarn global add jest
RUN yarn buildprod
# ADD setup.sh /app
# RUN ["chmod", "+x", "/app/setup.sh"]

# # Avoid CRLF windows bug
# RUN sed -i -e 's/\r$//' /app/setup.sh
# ENTRYPOINT ["/app/setup.sh"]

# production stage
FROM nginx:stable-alpine AS production-stage
COPY --from=build-stage /app/public /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
