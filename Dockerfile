# Use Node 18 (LTS)
FROM node:18

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the project
COPY . .

# Compile contracts (optional here; you can also run tests directly)
RUN npx hardhat compile

# Default command: run tests
CMD ["npx", "hardhat", "test"]
