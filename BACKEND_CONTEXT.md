# Rails Backend Context for Timer-App

This document provides complete context about the Rails backend structure for the timer-app project to assist with frontend development.

## Project Overview

This is a Rails 7.1 API backend for a timer application focused on yoga/meditation sessions with asanas (yoga poses). The app manages:
- **Sessions**: Collections of timed activities (like yoga flows)
- **Timers**: Individual timed segments within sessions
- **Asanas**: Detailed yoga pose information

## Database Schema

### Sessions Table
```sql
create_table "sessions" do |t|
  t.string "name"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.text "description"
end
```

### Timers Table
```sql
create_table "timers" do |t|
  t.integer "duration"        # Duration in seconds
  t.integer "session_id", null: false
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.string "title"
  # Foreign key to sessions
end
```

### Asanas Table
```sql
create_table "asanas" do |t|
  t.string "title"
  t.text "benefits"
  t.text "contraindications"
  t.text "alternatives_and_options"
  t.text "counterposes"
  t.text "meridians_and_organs"
  t.text "joints"
  t.string "recommended_time"
  t.text "other_notes"
  t.text "into_pose"
  t.text "out_of_pose"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.integer "session_id"              # Optional association
  t.text "similar_yang_asanas"
end
```

## Models and Relationships

### Session Model
```ruby
class Session < ApplicationRecord
  has_many :timers, dependent: :destroy
  has_many :asanas
  validates :name, presence: true
end
```

### Timer Model
```ruby
class Timer < ApplicationRecord
  belongs_to :session
  validates :duration, presence: true, numericality: { greater_than: 0 }
end
```

### Asana Model
```ruby
class Asana < ApplicationRecord
  # No validations or associations defined yet
end
```

## API Endpoints

### Sessions Controller

**GET /sessions**
- Returns all sessions with their associated timers
- Response: `sessions.to_json(include: :timers)`

**GET /sessions/:id**
- Returns a specific session with its timers
- Response: `session.to_json(include: :timers)`

**POST /sessions**
- Creates a new session
- Required params: `name`, optional: `description`
- Returns: Created session or validation errors

**PUT/PATCH /sessions/:id**
- Updates an existing session
- Accepts: `name`, `description`
- Returns: Updated session or validation errors

**DELETE /sessions/:id**
- Deletes a session (and all associated timers due to `dependent: :destroy`)
- Returns: 204 No Content

### Timers Controller

**POST /sessions/:session_id/timers**
- Creates a timer within a specific session
- Required params: `duration` (integer > 0), optional: `title`
- Returns: Created timer or validation errors

**DELETE /timers/:id**
- Deletes a specific timer
- Note: This is not nested, use direct timer ID
- Returns: 204 No Content

### Asanas Controller

**GET /asanas**
- Returns all asanas
- Response: Array of all asana objects

**GET /asanas/:id**
- Returns a specific asana
- Response: Single asana object

**GET /sessions/:session_id/asanas/:id**
- Returns a specific asana (alternative nested route)

## Sample Data Structure

### Predefined Flows
The backend includes 5 predefined yoga flows:

1. **"An Easy Beginner's Flow"** - 15 segments, ~27 minutes total
2. **"A Flow for the Spine (60min)"** - 11 segments, 60 minutes
3. **"A Flow for the Spine (90min)"** - 16 segments, 90 minutes
4. **"A Flow for the Hips (60min)"** - 12 segments, 60 minutes
5. **"A Flow for the Hips (90min)"** - 16 segments, 90 minutes

### Timer Durations
- Durations are stored in **seconds**
- Common durations: 60s, 90s, 120s, 180s, 240s, 300s, 420s, 600s
- Meditation segments: typically 180-300 seconds
- Pose holds: typically 90-300 seconds
- Transitions: typically 60-120 seconds

### Asana Information
Each asana includes comprehensive details:
- **title**: Pose name (e.g., "Butterfly", "Child's Pose", "Dragon")
- **benefits**: Physical and mental benefits
- **contraindications**: When to avoid the pose
- **into_pose**: Instructions for entering the pose
- **out_of_pose**: Instructions for exiting safely
- **alternatives_and_options**: Modifications and props
- **counterposes**: Recommended follow-up poses
- **meridians_and_organs**: Traditional Chinese Medicine connections
- **joints**: Body areas affected
- **recommended_time**: Suggested hold duration
- **similar_yang_asanas**: Related active yoga poses
- **other_notes**: Additional safety/technique notes

## Common Flow Patterns

### Typical Session Structure
1. **Opening Meditation** (3-5 minutes)
2. **Warm-up poses** (Hip openers like Butterfly, Straddle)
3. **Main sequence** (Target area focus - spine or hips)
4. **Backbends** (Sphinx, Seal, Camel)
5. **Lateral stretches** (Bananasana)
6. **Twists** (Reclining twists)
7. **Final relaxation** (Shavasana, 7-10 minutes)

### Timer Patterns
- Most poses are held 90-300 seconds (1.5-5 minutes)
- Meditation segments: 180-300 seconds
- Final relaxation: 420-600 seconds (7-10 minutes)
- Quick transitions: 60-120 seconds

## Technical Notes

### JSON Responses
- Sessions always include associated timers: `include: :timers`
- All timestamps in standard Rails format
- Durations always in seconds (convert to minutes/seconds for display)

### Validation Rules
- Session name is required
- Timer duration must be present and > 0
- Session-timer relationship is enforced with foreign key

### CORS Configuration
The app includes CORS configuration in `config/initializers/cors.rb` for frontend integration.

### Error Handling
- Validation errors return 422 Unprocessable Entity
- Not found errors return standard Rails 404
- Successful deletions return 204 No Content

## Development Data

The `db/seeds.rb` file populates:
- All asana definitions from the constants file
- All predefined flows as sessions with associated timers

Run `rails db:seed` to populate with sample data.

This backend provides a solid foundation for building timer-based yoga/meditation applications with rich pose information and flexible session management.
