FROM postgres:alpine AS builder

# install build tools
RUN apk add --no-cache git make clang19 llvm19

# build pgvector
RUN cd /tmp && \
    git clone --branch v0.8.1 https://github.com/pgvector/pgvector.git && \
    cd pgvector && \
    make && \
    make install

# use a new base image
FROM postgres:alpine

# copy pgvector
COPY --from=builder /usr/local/lib/postgresql/vector.so /usr/local/lib/postgresql/
COPY --from=builder /usr/local/share/postgresql/extension/* /usr/local/share/postgresql/extension/

# 'postgres:alpine' is already config all environment.
