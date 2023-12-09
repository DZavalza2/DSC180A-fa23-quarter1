# Start from a base image with R and Python
FROM debian:bullseye-slim

# Update package lists and install R and Python
RUN apt-get update && apt-get install -y \
    r-base \
    r-base-dev \
    python3 \
    python3-pip

# Install necessary R packages
RUN R -e "install.packages(c('RPostgreSQL', 'poLCA'), dependencies=TRUE)"

# Install necessary Python libraries for EDA
RUN pip3 install numpy pandas matplotlib seaborn scipy


# Set working directory
WORKDIR /usr/src/app

# Copy your project files into the image
COPY . .

