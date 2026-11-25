ARG PG_IMAGE=postgres:alpine

FROM ${PG_IMAGE} AS builder
ARG PGVECTOR_TAG

# install build tools
# - build-base: provides gcc/make for compiling the extension
# - clang/llvm: generate LLVM bitcode (.bc) for the JIT-enabled PostgreSQL build.
RUN LLVM_VER="$(sed -n '/^CLANG *=/{s/.*clang-//p;q}' "$(pg_config --pkglibdir)/pgxs/src/Makefile.global")" && \
    apk add --no-cache git build-base "clang${LLVM_VER:?}" "llvm${LLVM_VER}"

# build pgvector
RUN git clone --depth 1 --branch "${PGVECTOR_TAG}" \
        https://github.com/pgvector/pgvector.git /tmp/pgvector && \
    make -C /tmp/pgvector -j"$(nproc)" && \
    make -C /tmp/pgvector install

# use a new base image
FROM ${PG_IMAGE}

# copy pgvector
COPY --from=builder /usr/local/lib/postgresql/vector.so /usr/local/lib/postgresql/
COPY --from=builder /usr/local/lib/postgresql/bitcode/vector/ /usr/local/lib/postgresql/bitcode/vector/
COPY --from=builder /usr/local/lib/postgresql/bitcode/vector.index.bc /usr/local/lib/postgresql/bitcode/
COPY --from=builder /usr/local/share/postgresql/extension/ /usr/local/share/postgresql/extension/

# 'postgres:alpine' is already config all environment.
