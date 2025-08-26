# Evento Public API Documentation

## Overview

The Evento Public API provides programmatic access to public event data from the Evento platform. This RESTful API allows developers to retrieve event information, user events, and build integrations with Evento.

**Base URL**: `https://api.evento.so/api/public/v1`

**Version**: 1.0.0

## Authentication

All API requests require authentication via an API key. Include your API key in the request headers:

```http
x-evento-api-key: YOUR_API_KEY
```

### Example Request

```bash
curl -H "x-evento-api-key: YOUR_API_KEY" \
  https://api.evento.so/api/public/v1/events/EVENT_ID
```

### Obtaining an API Key

To obtain an API key, please contact the Evento development team. API keys are currently managed internally.

## Rate Limiting

Currently, there are no enforced rate limits. However, we recommend:
- Maximum 100 requests per minute per API key
- Implement exponential backoff for retries
- Cache responses when appropriate

Please use the API responsibly. Excessive usage may result in rate limiting being implemented.

## Endpoints

### Events

#### Get Event by ID

Retrieve detailed information about a specific event.

```http
GET /events/{eventId}
```

**Parameters:**
- `eventId` (path, required): The unique identifier of the event

**Response:**
```json
{
  "success": true,
  "message": "Event details fetched successfully",
  "data": {
    "id": "evt_abc123",
    "title": "Tech Meetup 2024",
    "description": "Join us for an evening of tech talks and networking",
    "cover": "https://example.com/event-cover.jpg",
    "location": "San Francisco, CA",
    "start_date": "2024-12-15T18:00:00Z",
    "end_date": "2024-12-15T21:00:00Z",
    "timezone": "America/Los_Angeles",
    "status": "published",
    "visibility": "public",
    "cost": 0,
    "created_at": "2024-11-01T10:00:00Z",
    "creator": {
      "id": "usr_xyz789",
      "username": "techorg",
      "image": "https://example.com/avatar.jpg",
      "verification_status": "verified"
    },
    "links": {
      "spotify_url": null,
      "wavlake_url": null
    },
    "contributions": {
      "cashapp": "$techorg",
      "venmo": "@techorg",
      "paypal": null,
      "btc_lightning": null
    }
  }
}
```

### User Events

#### Get User's Events

Retrieve all public events created by a specific user.

```http
GET /users/{username}/events
```

**Parameters:**
- `username` (path, required): The username of the user
- `since` (query, optional): Filter events starting from this date (ISO 8601 format)
- `from` (query, optional): Alias for `since`
- `to` (query, optional): Filter events up to this date (ISO 8601 format)

**Example:**
```bash
curl -H "x-evento-api-key: YOUR_API_KEY" \
  "https://api.evento.so/api/public/v1/users/johndoe/events?since=2024-01-01T00:00:00Z&to=2024-12-31T23:59:59Z"
```

#### Get User's Profile Events

Retrieve all events created by or RSVP'd to by a user. This includes both hosted events and events the user is attending.

```http
GET /users/{username}/profile-events
```

**Parameters:**
- `username` (path, required): The username of the user
- `since` (query, optional): Filter events starting from this date (ISO 8601 format)
- `from` (query, optional): Alias for `since`
- `to` (query, optional): Filter events up to this date (ISO 8601 format)

#### Get User's Upcoming Events

Retrieve upcoming events hosted by a specific user.

```http
GET /users/{username}/upcoming-events
```

**Parameters:**
- `username` (path, required): The username of the user
- `limit` (query, optional): Number of results to return (1-100, default: all)
- `offset` (query, optional): Number of results to skip for pagination

**Example:**
```bash
curl -H "x-evento-api-key: YOUR_API_KEY" \
  "https://api.evento.so/api/public/v1/users/johndoe/upcoming-events?limit=10&offset=0"
```

**Response:**
```json
{
  "success": true,
  "message": "Upcoming events fetched successfully for user johndoe",
  "data": [
    {
      "id": "evt_future1",
      "title": "Summer Festival 2025",
      "description": "Annual summer celebration",
      "cover": "https://example.com/summer-cover.jpg",
      "location": "Central Park, NY",
      "start_date": "2025-06-21T14:00:00Z",
      "end_date": "2025-06-21T22:00:00Z",
      "timezone": "America/New_York",
      "status": "published",
      "visibility": "public",
      "cost": 25.00,
      "created_at": "2024-11-15T09:00:00Z",
      "creator": {
        "id": "usr_123",
        "username": "johndoe",
        "image": "https://example.com/johndoe.jpg",
        "verification_status": "verified"
      },
      "links": {
        "spotify_url": "https://spotify.com/playlist/summer2025",
        "wavlake_url": null
      },
      "contributions": {
        "cashapp": "$johndoe",
        "venmo": "@johndoe",
        "paypal": "johndoe@example.com",
        "btc_lightning": null
      }
    }
  ]
}
```

#### Get User's Past Events

Retrieve past events hosted by a specific user, ordered by most recent first.

```http
GET /users/{username}/past-events
```

**Parameters:**
- `username` (path, required): The username of the user
- `limit` (query, optional): Number of results to return (1-100, default: all)
- `offset` (query, optional): Number of results to skip for pagination

## Response Format

All API responses follow a consistent format:

### Success Response

```json
{
  "success": true,
  "message": "Descriptive success message",
  "data": { /* Response data */ }
}
```

### Error Response

```json
{
  "success": false,
  "message": "Error description"
}
```

## Event Object

The event object contains the following fields:

| Field | Type | Description |
|-------|------|-------------|
| `id` | string | Unique event identifier |
| `title` | string | Event title |
| `description` | string | Event description (may contain markdown) |
| `cover` | string | URL to event cover image |
| `location` | string | Event location (address or venue name) |
| `start_date` | string | Event start date/time (ISO 8601) |
| `end_date` | string \| null | Event end date/time (ISO 8601) |
| `timezone` | string | Event timezone (IANA timezone) |
| `status` | string | Event status (always "published" for public API) |
| `visibility` | string | Event visibility (always "public" for public API) |
| `cost` | number \| null | Event cost in USD (null = free) |
| `created_at` | string | Event creation timestamp (ISO 8601) |
| `creator` | object | Event creator information |
| `links` | object | External links (Spotify, Wavlake) |
| `contributions` | object | Payment/donation methods |

### Creator Object

| Field | Type | Description |
|-------|------|-------------|
| `id` | string | User ID |
| `username` | string | Username |
| `image` | string | Profile image URL |
| `verification_status` | string \| null | User verification status |

## Error Codes

| Status Code | Description |
|------------|-------------|
| 200 | Success |
| 400 | Bad Request - Invalid parameters or request format |
| 401 | Unauthorized - Invalid or missing API key |
| 404 | Not Found - Resource not found |
| 500 | Internal Server Error |

### Common Error Responses

**401 Unauthorized:**
```json
{
  "success": false,
  "message": "Not authenticated."
}
```

**400 Bad Request:**
```json
{
  "success": false,
  "message": "Username is required"
}
```

**404 Not Found:**
```json
{
  "success": false,
  "message": "Not found."
}
```

## Filtering and Pagination

### Date Filtering

Events can be filtered by date range using query parameters:
- `since` or `from`: Events starting from this date (inclusive)
- `to`: Events up to this date (inclusive)

Dates must be in ISO 8601 format: `YYYY-MM-DDTHH:mm:ssZ`

### Pagination

For endpoints that support pagination:
- `limit`: Number of results per page (max 100)
- `offset`: Number of results to skip

Example pagination request:
```bash
# Get second page of 20 results
curl -H "x-evento-api-key: YOUR_API_KEY" \
  "https://api.evento.so/api/public/v1/users/johndoe/past-events?limit=20&offset=20"
```

## Data Considerations

1. **Public Data Only**: The API only returns events with:
   - `status: "published"`
   - `visibility: "public"`

2. **Event Timing**:
   - Past events: `computed_start_date < current_time`
   - Upcoming events: `computed_start_date >= current_time`

3. **Sorting**:
   - Upcoming events: Ascending by start date
   - Past events: Descending by start date (most recent first)
   - General event lists: Descending by creation date

## SDK Support

Official SDKs are planned for the following languages:
- JavaScript/TypeScript
- Python
- Ruby
- Go

Check our [GitHub repository](https://github.com/evento) for SDK availability and examples.

## Webhooks

Webhook support is planned for future releases. This will allow real-time notifications for:
- New events created
- Event updates
- Event cancellations
- RSVP changes

## Best Practices

1. **Caching**: Implement appropriate caching to reduce API calls
2. **Error Handling**: Always check the `success` field before processing data
3. **Pagination**: Use pagination for large result sets
4. **Date Filtering**: Use date filters to retrieve only relevant events
5. **Respect Rate Limits**: Even without enforced limits, use the API responsibly

## Examples

### JavaScript/Node.js

```javascript
const EVENTO_API_KEY = 'YOUR_API_KEY';
const BASE_URL = 'https://api.evento.so/api/public/v1';

async function getUserUpcomingEvents(username) {
  const response = await fetch(
    `${BASE_URL}/users/${username}/upcoming-events?limit=10`,
    {
      headers: {
        'x-evento-api-key': EVENTO_API_KEY
      }
    }
  );
  
  const data = await response.json();
  
  if (!data.success) {
    throw new Error(data.message);
  }
  
  return data.data;
}
```

### Python

```python
import requests

EVENTO_API_KEY = 'YOUR_API_KEY'
BASE_URL = 'https://api.evento.so/api/public/v1'

def get_event(event_id):
    headers = {'x-evento-api-key': EVENTO_API_KEY}
    response = requests.get(f'{BASE_URL}/events/{event_id}', headers=headers)
    
    data = response.json()
    
    if not data['success']:
        raise Exception(data['message'])
    
    return data['data']
```

### cURL

```bash
# Get all events for a user with date filtering
curl -H "x-evento-api-key: YOUR_API_KEY" \
  "https://api.evento.so/api/public/v1/users/johndoe/events?since=2024-01-01T00:00:00Z"

# Get specific event details
curl -H "x-evento-api-key: YOUR_API_KEY" \
  "https://api.evento.so/api/public/v1/events/evt_abc123"

# Get user's profile events (created + RSVP'd)
curl -H "x-evento-api-key: YOUR_API_KEY" \
  "https://api.evento.so/api/public/v1/users/johndoe/profile-events"
```

## Changelog

### Version 1.0.0 (2024-11-26)
- Renamed API path from `/api/ext/v1` to `/api/public/v1`
- Reorganized endpoints to be more RESTful
- Renamed `/profile` endpoint to `/profile-events` for clarity
- Moved all user-related endpoints under `/users/{username}/`
- Improved documentation and added comprehensive examples

## Support

For API support, bug reports, or feature requests:
- Email: api-support@evento.so
- GitHub Issues: [https://github.com/evento/api-issues](https://github.com/evento/api-issues)
- Developer Forum: [https://developers.evento.so](https://developers.evento.so)

## Terms of Service

By using the Evento Public API, you agree to:
- Not abuse or overload the service
- Not use the API for malicious purposes
- Respect user privacy and data
- Follow all applicable laws and regulations

Full terms of service: [https://evento.so/terms](https://evento.so/terms)