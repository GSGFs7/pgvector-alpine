## What's this?

A PostgreSQL Docker image with pgvector extension built on Alpine Linux.

## Why it here?

I encountered a confusing docker error when use [pgvector docker images](https://hub.docker.com/r/pgvector/pgvector):

```
failed to convert whiteout file "xxx": operation not permitted
```

But everything is fine on alpine based images. So, I try to build an alpine based pgvector image.

## Usage

Same as pgvector. Pulling the image from dorker hub:

```bash
docker pull gsgfs/pgvector-alpine
```
