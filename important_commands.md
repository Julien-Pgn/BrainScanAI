Important commands:

Getting the list of libraries installed in the NGC container:
docker run --rm nvcr.io/nvidia/pytorch:25.01-py3     pip freeze > ngc_container_libraries.txt