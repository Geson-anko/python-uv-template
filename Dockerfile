FROM ubuntu:latest

RUN mkdir -p /workspace
WORKDIR /workspace
COPY . .

# Setup dependencies
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    curl \
    make \
    just \
    bash-completion \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* \
# Setup Bash Completion
&& echo '[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion' >> ~/.bashrc

# Setup uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
ENV UV_LINK_MODE=copy

# Setup shell completions and environment
RUN echo 'eval "$(uv generate-shell-completion bash)"' >> ~/.bashrc \
&& echo 'eval "$(just --completions bash)"' >> ~/.bashrc \
&& make venv \
&& uv run pre-commit install \
&& echo "eval '$(uv run python src/train.py -sc install=bash)'" >> ~/.bashrc \
&& echo "source /workspace/.venv/bin/activate" >> ~/.bashrc

# Console setup
CMD [ "bash" ]
