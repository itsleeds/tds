FROM ghcr.io/itsleeds/tds

# Ensure the binder default user (jovyan, uid 1000) owns the workspace so
# the non-root runtime can edit files. This prevents permission denied
# errors when opening the repository in Binder.
USER root
RUN mkdir -p /home/jovyan/work /workspace \
	&& chown -R 1000:1000 /home/jovyan /workspace
USER 1000

# repo2docker will copy the repository contents into the image at build time
