# Rocky Linux 8 test environment for portable dotfiles
#
# Build:
#   docker build -t minimal-dotfiles .
#
# Run (mount configs for live editing):
#   docker run -it -v /path/to/configs:/home/devuser/configs minimal-dotfiles
#
# Configs are bind-mounted, so edits on the host are immediately visible.
# deploy.sh runs on startup to symlink configs into place.
FROM rockylinux:8

# EPEL for extra packages
RUN dnf install -y epel-release && dnf clean all

# Core CLI tools
RUN dnf install -y \
    git \
    tmux \
    zsh \
    ripgrep \
    fzf \
    jq \
    tree \
    bat \
    dos2unix \
    htop \
    fd-find \
    curl \
    && dnf clean all

# Neovim 0.8 via appimage (tarball needs glibc 2.29, Rocky 8 has 2.28)
# Extract appimage since FUSE isn't available in Docker
RUN curl -Lo /tmp/nvim.appimage https://github.com/neovim/neovim/releases/download/v0.8.3/nvim.appimage \
    && chmod +x /tmp/nvim.appimage \
    && cd /tmp && ./nvim.appimage --appimage-extract \
    && mv /tmp/squashfs-root /opt/nvim \
    && ln -s /opt/nvim/AppRun /usr/local/bin/nvim \
    && rm /tmp/nvim.appimage

# Zoxide 0.9.4
RUN curl -Lo /tmp/zoxide.tar.gz https://github.com/ajeetdsouza/zoxide/releases/download/v0.9.4/zoxide-0.9.4-x86_64-unknown-linux-musl.tar.gz \
    && tar xzf /tmp/zoxide.tar.gz -C /usr/local/bin zoxide \
    && rm /tmp/zoxide.tar.gz

# Create a non-root user
RUN useradd -m -s /bin/zsh devuser
USER devuser
WORKDIR /home/devuser

# Configs will be bind-mounted at ~/configs
# Entrypoint runs deploy.sh then drops into zsh
COPY --chown=devuser:devuser entrypoint.sh /home/devuser/entrypoint.sh
ENTRYPOINT ["/home/devuser/entrypoint.sh"]
