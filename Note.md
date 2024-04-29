## Refactor Deploy Script
The principles include considerations for gas optimizations, thorough auditing, key management, and verifying your source code

Best practice for deployment scripts involves minimizing state changes and contract deployments. In this context, the conditions that deploy mock contracts should be specifically triggered only when necessary, such as when on a local development network like Anvil.
Since the configurations for different networks are hardcoded and thus predictable, deploying mocks could be avoided in live networks altogether, which would save gas and reduce the deployment footprint.