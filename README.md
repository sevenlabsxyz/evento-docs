# Evento API Documentation

[![Built with Mintlify](https://img.shields.io/badge/Built%20with-Mintlify-mint.svg)](https://mintlify.com)

This repository contains the official documentation for the Evento API, built with [Mintlify](https://mintlify.com). The Evento API provides access to public event data from the Evento platform.

## 🚀 Live Documentation

Visit the live documentation at: [https://docs.evento.so](https://docs.evento.so)

## 📋 About the API

The Evento API is a simple REST API that allows you to:

- **Retrieve Public Events**: Get all public events associated with a specific username
- **Access Event Details**: Complete event information including dates, location, and creator details
- **Simple Authentication**: Header-based API key authentication

### Key Features

- **Single Endpoint**: One simple GET endpoint for all public events
- **Rich Data Structure**: Comprehensive event details with multiple date formats
- **Creator Information**: Event creator details including verification status
- **No Rate Limiting**: Currently no limits on API usage
- **JSON Responses**: Clean, structured data format

## 🛠️ Development

### Prerequisites

- Node.js 18 or higher
- npm or yarn

### Installation

1. Clone this repository:

   ```bash
   git clone https://github.com/evento/api-docs.git
   cd api-docs
   ```

2. Install the Mintlify CLI:

   ```bash
   npm i -g mintlify
   ```

3. Start the development server:

   ```bash
   mintlify dev
   ```

4. Open [http://localhost:3000](http://localhost:3000) to view the documentation locally.

### File Structure

```
evento-docs/
├── api-reference/
│   └── get.mdx          # API endpoint documentation
├── images/
│   └── logo.svg         # Evento logo
├── index.mdx            # Introduction page
├── docs.json            # Mintlify configuration
└── README.md            # This file
```

### Making Changes

- **Content**: Edit `.mdx` files in the root and `api-reference/` directories
- **Navigation**: Update `docs.json` to modify the site structure
- **Styling**: Customize colors and branding in `docs.json`

### Components Used

This documentation makes extensive use of Mintlify's component library:

- **Cards & CardGroups**: Feature highlights and navigation
- **Callouts**: Info, Warning, Note, Tip messages
- **Accordions**: Collapsible content sections
- **Code Groups**: Multi-language code examples
- **Response Fields**: API response documentation
- **Param Fields**: API parameter documentation

## 🔑 API Access

To use the Evento API, you need an API key. Contact our team to get started:

**[Schedule API Access Call →](https://cal.com/evento/api)**

## 📚 Documentation Structure

### Getting Started (`index.mdx`)

- API overview and introduction
- Authentication guide
- HTTP status codes
- Quick start examples

### API Reference (`api-reference/get.mdx`)

- Detailed endpoint documentation
- Request/response examples
- Error handling
- Code samples in multiple languages

## 🤝 Contributing

We welcome contributions to improve the documentation! Here's how you can help:

1. **Fork** this repository
2. **Create** a feature branch (`git checkout -b feature/amazing-improvement`)
3. **Make** your changes
4. **Test** locally with `mintlify dev`
5. **Commit** your changes (`git commit -m 'Add amazing improvement'`)
6. **Push** to the branch (`git push origin feature/amazing-improvement`)
7. **Open** a Pull Request

### Content Guidelines

- Use clear, concise language
- Include code examples where helpful
- Follow the existing component patterns
- Test all links and references
- Ensure mobile responsiveness

## 📞 Support

Need help with the API or documentation?

- **Technical Support**: [Schedule a call](https://cal.com/evento/api)
- **API Access**: [Get your API key](https://cal.com/evento/api)
- **Issues**: Open an issue in this repository

## 🔗 Links

- **Evento Platform**: [evento.so](https://evento.so)
- **API Documentation**: [docs.evento.so](https://docs.evento.so)
- **Mintlify**: [mintlify.com](https://mintlify.com)

## 📄 License

This documentation is licensed under the MIT License. See [LICENSE](LICENSE) for details.

---

Built with ❤️ by the Evento team using [Mintlify](https://mintlify.com)
