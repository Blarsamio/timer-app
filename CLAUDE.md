# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Rails 7.1 API backend for a timer-based yoga/meditation application. The app manages structured yoga flows with detailed pose (asana) information.

**Core entities:**
- **Sessions**: Named collections of timed activities (yoga flows)
- **Timers**: Individual timed segments within sessions (pose holds, transitions, meditation)
- **Asanas**: Comprehensive yoga pose database with benefits, contraindications, instructions

## Development Environment

**Ruby version**: 3.3.5
**Rails version**: 7.1.3.4
**Database**: SQLite3 (development/test)

### Common Development Commands

Start the development server:
```bash
rails server
# or
rails s
```

Database operations:
```bash
# Setup database
rails db:create db:migrate

# Seed with predefined yoga flows and asana data
rails db:seed

# Reset database with fresh data
rails db:drop db:create db:migrate db:seed

# Generate new migration
rails generate migration MigrationName

# Run specific migration
rails db:migrate:up VERSION=timestamp
```

Testing:
```bash
# Run all tests
rails test

# Run specific test file
rails test test/models/session_test.rb

# Run specific test method
rails test test/models/session_test.rb -n test_method_name

# Run tests with verbose output
rails test -v
```

Console and debugging:
```bash
# Open Rails console
rails console
# or
rails c

# Open console in specific environment
rails console production
```

## Application Architecture

### Database Schema Relationships

```
sessions (1) ─────── (many) timers
    │
    └─── (many) asanas (optional association)
```

**Sessions**: Core flow containers with name and description
**Timers**: Ordered time segments (duration in seconds, optional title)
**Asanas**: Rich pose data (benefits, contraindications, instructions, etc.)

### API Routes Structure

```ruby
# Sessions CRUD with nested timers
resources :sessions do
  resources :timers, only: [:create, :destroy]
  resources :asanas, only: [:show]  # Nested asana view
end

# Standalone asana access
resources :asanas, only: [:index, :show]
```

### Key Model Patterns

**Session model** (`app/models/session.rb`):
- `has_many :timers, dependent: :destroy` (cascading delete)
- `has_many :asanas` (optional association)
- Validates name presence

**Timer model** (`app/models/timer.rb`):
- `belongs_to :session` (required)
- Validates duration > 0
- Duration stored in seconds

**Asana model** (`app/models/asana.rb`):
- Comprehensive pose information fields
- Optional session association

### Controller Response Patterns

**Sessions always include timers**:
```ruby
render json: sessions.to_json(include: :timers)
```

**Standard error responses**:
- 422 Unprocessable Entity for validation errors
- 404 Not Found for missing records
- 204 No Content for successful deletions

### Data Patterns

**Timer durations** (stored in seconds):
- Quick transitions: 60-120s
- Pose holds: 90-300s
- Meditation segments: 180-300s
- Final relaxation: 420-600s

**Predefined content**:
- 5 complete yoga flows with timers
- Comprehensive asana database with TCM meridian info
- Typical flow: Opening meditation → Warm-up → Main sequence → Backbends → Twists → Final relaxation

## Technical Configuration

**CORS**: Configured for cross-origin requests (`config/initializers/cors.rb`)
**Test environment**: Parallel test execution enabled
**Dependencies**: pdf-reader for document processing, rack-cors for API access

## Development Guidelines

**Database changes**: Always use migrations, never edit schema.rb directly
**API responses**: Sessions should include associated timers using `include: :timers`
**Validation**: Enforce model validations (session name required, timer duration > 0)
**Associations**: Leverage `dependent: :destroy` for proper cascade deletion
**Seeds**: Use `rails db:seed` to populate development data

## Testing Approach

Tests located in `test/` directory with standard Rails minitest structure:
- `test/models/` - Model unit tests
- `test/controllers/` - Controller integration tests
- `test/fixtures/` - Test data fixtures

Run tests frequently during development and ensure all tests pass before commits.