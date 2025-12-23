# Skill Examples for Kompass

This file contains concrete examples of skills that would be valuable for this Rails event-sourced codebase.

## Example 1: Complete Event-Sourced Feature Skill

This is a **HIGH-VALUE** skill candidate because it involves 5+ coordinated steps that must happen in specific order.

---

```markdown
---
name: generating-duty-features
description: Generate complete event-sourced Duty features including Commands, Deciders, Events, Reactors, and ReadModels. Use when building new Duty domain functionality.
---

# Generating Duty Features

Create event-sourced features for the Duty domain following CQRS patterns.

## Workflow

### 1. Create the Command

\`\`\`ruby
# app/eventing/commands/duty/[action].rb
module Commands
  module Duty
    class [Action] < Commands::Base
      attribute :duty_id, Types::String
      attribute :client_id, Types::String
      attribute :name, Types::String
      attribute :metadata, CommandMetadata.optional

      validates :duty_id, :client_id, :name, presence: true
    end
  end
end
\`\`\`

### 2. Implement the Decider

\`\`\`ruby
# app/eventing/deciders/duty/[action].rb
module Deciders
  module Duty
    class [Action] < Deciders::Base
      def call(command)
        duty = Repos::Duty.new.find_by_id(command.duty_id)
        return Failure(reason: :not_found) unless duty

        event = Events::Duty::[EventName].new(
          duty_id: command.duty_id,
          client_id: command.client_id,
          name: command.name,  # Keyword shorthand!
          valid_at: command.metadata&.valid_at || Time.current
        )

        Success(event)
      end
    end
  end
end
\`\`\`

### 3. Define the Event

\`\`\`ruby
# app/eventing/events/duty/[event_name].rb
module Events
  module Duty
    class [EventName] < Events::Base
      attribute :duty_id, Types::String
      attribute :client_id, Types::String
      attribute :name, Types::String

      validates :duty_id, :client_id, :name, presence: true
    end
  end
end
\`\`\`

### 4. Create Reactor

\`\`\`ruby
# app/eventing/reactors/duty/[event_name]_reactor.rb
module Reactors
  module Duty
    class [EventName]Reactor < Reactors::Base
      subscribes_to Events::Duty::[EventName]

      def call(event)
        ReadModels::Duty::Duty.upsert(
          {
            id: event.duty_id,
            client_id: event.client_id,
            name: event.name,
            valid_from: event.valid_at,
            valid_to: nil
          },
          unique_by: :id
        )

        Success()
      end
    end
  end
end
\`\`\`

### 5. Write Tests

\`\`\`ruby
# spec/eventing/deciders/duty/[action]_spec.rb
RSpec.describe Deciders::Duty::[Action] do
  describe "successful scenarios" do
    it "creates event with correct duty data" do
      command = Commands::Duty::[Action].new(
        duty_id:,
        client_id:,
        name:
      )

      result = described_class.call(command)

      expect(result).to be_success
      event = result.success
      expect(event.duty_id).to eq(duty_id)
      expect(event.name).to eq(name)
    end
  end

  describe "validation failures" do
    it "fails when duty not found" do
      result = described_class.call(command)
      expect(result).to be_failure.with(reason: :not_found)
    end
  end
end
\`\`\`

### 6. Run Tests

\`\`\`bash
bundle exec rspec spec/eventing/deciders/duty/[action]_spec.rb
bundle exec rspec spec/eventing/reactors/duty/[event_name]_reactor_spec.rb
\`\`\`

## Validation Checklist

- [ ] Command has all required attributes
- [ ] Decider handles success and failure cases
- [ ] Event has proper validations
- [ ] Reactor updates read model with temporal data
- [ ] All tests passing
- [ ] Uses keyword shorthand throughout
- [ ] Uses `bin/rails` for commands
```

**Why this is a good skill:**
- ✅ 6 coordinated steps in specific order
- ✅ Complex workflow with decision points
- ✅ Easy to miss steps (e.g., reactor subscription, temporal data)
- ✅ Domain-specific conventions (valid_at, keyword shorthand)
- ✅ Validation loop (test → fix → repeat)

**Why not just CLAUDE.md:**
- ❌ Too complex for general documentation
- ❌ Specific execution order matters
- ❌ Easy to forget reactor subscription or temporal fields

---

## Example 2: Testing Pattern Skill

This is a **MEDIUM-VALUE** skill because it codifies specific testing philosophy.

---

```markdown
---
name: writing-decider-specs
description: Write behavior-focused RSpec tests for Deciders that validate business logic without testing implementation details. Use when creating test coverage for Decider classes.
---

# Writing Decider Specs

Write focused tests for Deciders that test behavior, not implementation.

## Core Philosophy

**Test BEHAVIOR:**
- ✅ Correct event created with right data
- ✅ Validation failures return proper errors
- ✅ Noop conditions detected
- ✅ Business rule edge cases

**DON'T Test IMPLEMENTATION:**
- ❌ Inheritance from Deciders::Base
- ❌ Method existence (respond_to?)
- ❌ Internal method calls
- ❌ Private method behavior

## Test Structure

\`\`\`ruby
RSpec.describe Deciders::[Domain]::[Action] do
  let(:entity_id) { "test-id" }
  let(:command) do
    Commands::[Domain]::[Action].new(
      entity_id:,
      attribute: value
    )
  end

  describe "successful scenarios" do
    it "creates event with correct data" do
      result = described_class.call(command)

      expect(result).to be_success
      event = result.success
      expect(event.entity_id).to eq(entity_id)
      expect(event.attribute).to eq(value)
      expect(event.valid_at).to be_present
    end
  end

  describe "noop scenarios" do
    it "returns noop when action already completed" do
      # Setup condition where action is already done

      result = described_class.call(command)

      expect(result).to be_noop
    end
  end

  describe "validation failures" do
    context "when entity not found" do
      it "fails with not_found reason" do
        result = described_class.call(command)

        expect(result).to be_failure.with(reason: :not_found)
      end
    end

    context "when validation fails" do
      let(:command) do
        Commands::[Domain]::[Action].new(
          entity_id:,
          invalid_attribute: bad_value
        )
      end

      it "fails with validation errors" do
        result = described_class.call(command)

        expect(result).to be_failure.with(
          reason: :invalid,
          errors: [ValidationError.new(:attribute, :error_type)]
        )
      end
    end
  end
end
\`\`\`

## Key Patterns

**Use proper matchers:**
- `be_success` - For successful operations
- `be_failure.with(reason: :code)` - For failures
- `be_noop` - For no-op scenarios

**Access results correctly:**
\`\`\`ruby
event = result.success  # Get event from Success result
errors = result.failure # Get failure data
\`\`\`

**Test actual values:**
\`\`\`ruby
# ✅ GOOD - Tests actual data
expect(event.duty_id).to eq(expected_duty_id)
expect(event.name).to eq(expected_name)

# ❌ BAD - Only tests presence
expect(event.duty_id).to be_present
\`\`\`

## Anti-Patterns to Avoid

\`\`\`ruby
# ❌ BAD - Tests inheritance
it "derives from Deciders::Base" do
  expect(described_class.ancestors).to include(Deciders::Base)
end

# ❌ BAD - Tests method existence
it "responds to call" do
  expect(described_class).to respond_to(:call)
end

# ❌ BAD - Tests internal calls
it "calls the repository" do
  expect(repo).to receive(:find_by_id)
  described_class.call(command)
end

# ✅ GOOD - Tests behavior
it "creates event when entity exists" do
  result = described_class.call(command)
  expect(result).to be_success
  expect(result.success.entity_id).to eq(entity_id)
end
\`\`\`

## Checklist

- [ ] Tests success scenarios with correct data
- [ ] Tests all validation failure paths
- [ ] Tests noop conditions
- [ ] Tests business rule edge cases
- [ ] No tests for inheritance or method existence
- [ ] No tests for internal implementation
- [ ] Uses proper matchers (be_success, be_failure, be_noop)
```

**Why this is a good skill:**
- ✅ Specific testing philosophy unique to this codebase
- ✅ Clear patterns to follow
- ✅ Common mistakes to avoid
- ✅ Examples show exactly what to test

**Why not just CLAUDE.md:**
- ✅ Could be in CLAUDE.md, but detailed examples benefit from skill format
- ✅ Frequently referenced when writing tests
- ✅ Provides executable templates

---

## Example 3: Simple Workflow Skill

This is a **LOW-VALUE** skill - probably better as CLAUDE.md documentation.

---

```markdown
---
name: generating-migrations
description: Generate and run database migrations using bin/rails. Use when creating or modifying database tables.
---

# Generating Migrations

Create database migrations for schema changes.

## Quick Start

\`\`\`bash
bin/rails generate migration [MigrationName]
\`\`\`

## Examples

\`\`\`bash
bin/rails generate migration AddColumnToTable column:type
bin/rails generate migration CreateTableName name:string
\`\`\`

## Run Migration

\`\`\`bash
bin/rails db:migrate
\`\`\`
```

**Why this is NOT a good skill:**
- ❌ Only 2 simple steps
- ❌ No complex decision points
- ❌ Claude already knows this
- ❌ No specific order requirements beyond "generate then run"
- ❌ Better as CLAUDE.md entry: "Always use `bin/rails` not `rails`"

---

## Example 4: Multi-Step Process Skill

This is a **HIGH-VALUE** skill for complex processes with validation loops.

---

```markdown
---
name: building-temporal-queries
description: Implement temporal queries using valid_at, created_at, and as_of parameters for event-sourced entities. Use when building time-aware query functionality.
---

# Building Temporal Queries

Implement time-travel queries for event-sourced read models.

## Temporal Data Model

Every read model has:
- `valid_from`: When this version became valid (from event.valid_at)
- `valid_to`: When this version was superseded (NULL for current)
- `created_at`: When the record was physically created

## Implementation Steps

### 1. Ensure Read Model Has Temporal Fields

\`\`\`ruby
# db/migrate/[timestamp]_add_temporal_fields_to_[table].rb
class AddTemporalFieldsTo[Table] < ActiveRecord::Migration[8.0]
  def change
    add_column :[table], :valid_from, :datetime, null: false
    add_column :[table], :valid_to, :datetime
    add_index :[table], [:id, :valid_from, :valid_to]
  end
end
\`\`\`

\`\`\`bash
bin/rails db:migrate
\`\`\`

### 2. Add Scopes to Read Model

\`\`\`ruby
# app/eventing/read_models/[domain]/[entity].rb
module ReadModels
  module [Domain]
    class [Entity] < ReadModels::Base
      scope :active, -> { where(valid_to: nil) }

      scope :as_of, ->(timestamp) {
        where("valid_from <= ?", timestamp)
          .where("valid_to IS NULL OR valid_to > ?", timestamp)
      }
    end
  end
end
\`\`\`

### 3. Update Reactor for Temporal Updates

\`\`\`ruby
# app/eventing/reactors/[domain]/[event_name]_reactor.rb
module Reactors
  module [Domain]
    class [EventName]Reactor < Reactors::Base
      subscribes_to Events::[Domain]::[EventName]

      def call(event)
        # Close previous version
        ReadModels::[Domain]::[Entity]
          .where(id: event.entity_id, valid_to: nil)
          .update_all(valid_to: event.valid_at)

        # Insert new version
        ReadModels::[Domain]::[Entity].create!(
          id: event.entity_id,
          attribute: event.attribute,
          valid_from: event.valid_at,
          valid_to: nil
        )

        Success()
      end
    end
  end
end
\`\`\`

### 4. Add Repository Methods

\`\`\`ruby
# app/eventing/repos/[entity].rb
module Repos
  class [Entity] < Repos::Base
    def find_by_id(id, as_of: nil)
      query = ReadModels::[Domain]::[Entity].where(id:)
      query = query.as_of(as_of) if as_of
      query.first
    end

    def all(as_of: nil)
      query = ReadModels::[Domain]::[Entity].active
      query = query.as_of(as_of) if as_of
      query.all
    end
  end
end
\`\`\`

### 5. Write Tests

\`\`\`ruby
RSpec.describe Repos::[Entity] do
  describe "#find_by_id with as_of" do
    it "returns version valid at specified time" do
      # Create entity with temporal versions

      past_version = repo.find_by_id(id, as_of: 1.day.ago)
      current_version = repo.find_by_id(id)

      expect(past_version.attribute).to eq(old_value)
      expect(current_version.attribute).to eq(new_value)
    end
  end
end
\`\`\`

### 6. Validate

\`\`\`bash
bundle exec rspec spec/eventing/repos/[entity]_spec.rb
bundle exec rspec spec/eventing/reactors/[domain]/[event_name]_reactor_spec.rb
\`\`\`

## Key Patterns

**Setting valid_from:**
\`\`\`ruby
valid_from: event.valid_at  # NOT Time.current!
\`\`\`

**Closing previous versions:**
\`\`\`ruby
.where(id: entity_id, valid_to: nil)
.update_all(valid_to: event.valid_at)
\`\`\`

**Querying at point in time:**
\`\`\`ruby
query.as_of(timestamp) if timestamp
\`\`\`

## Common Mistakes

❌ **Using Time.current instead of event.valid_at**
\`\`\`ruby
# BAD
valid_from: Time.current

# GOOD
valid_from: event.valid_at
\`\`\`

❌ **Forgetting to close previous versions**
\`\`\`ruby
# BAD - Just insert new version
ReadModels::Entity.create!(...)

# GOOD - Close old, then insert new
ReadModels::Entity.where(id:, valid_to: nil).update_all(valid_to: event.valid_at)
ReadModels::Entity.create!(...)
\`\`\`

❌ **Not indexing temporal fields**
\`\`\`ruby
# GOOD
add_index :table, [:id, :valid_from, :valid_to]
\`\`\`

## Validation Checklist

- [ ] Migration adds valid_from and valid_to
- [ ] Temporal fields indexed
- [ ] Read model has active and as_of scopes
- [ ] Reactor closes previous version before inserting
- [ ] Reactor uses event.valid_at not Time.current
- [ ] Repository supports as_of parameter
- [ ] Tests verify temporal queries work correctly
```

**Why this is a good skill:**
- ✅ 6 coordinated steps in specific order
- ✅ Easy to make mistakes (using Time.current vs event.valid_at)
- ✅ Complex validation loop
- ✅ Domain-specific pattern not obvious
- ✅ Multiple decision points

---

## Skill Selection Guidelines

### HIGH-VALUE Skills (Create These)

1. **generating-event-sourced-features** - Full CQRS flow
2. **building-temporal-queries** - Complex temporal patterns
3. **creating-background-workflows** - Commands::Async patterns
4. **implementing-exclusive-claims** - Conflict prevention
5. **writing-system-specs** - Capybara + Turbo patterns

### MEDIUM-VALUE Skills (Maybe)

1. **writing-focused-specs** - Testing philosophy (could be CLAUDE.md)
2. **creating-stimulus-controllers** - If complex patterns emerge
3. **building-turbo-forms** - If form patterns are intricate

### LOW-VALUE Skills (Don't Create)

1. **generating-migrations** - Too simple, Claude knows this
2. **running-tests** - Single command
3. **using-keyword-shorthand** - Simple convention, belongs in CLAUDE.md

## Decision Framework

Ask yourself:

1. **Steps:** Does it require 3+ coordinated steps? (If no, probably not a skill)
2. **Order:** Does execution order matter? (If no, probably not a skill)
3. **Mistakes:** Is it easy to make mistakes? (If no, probably not a skill)
4. **Domain:** Is it domain-specific? (If no, probably not a skill)
5. **Validation:** Does it have validation loops? (If no, consider if it's needed)

If you answered "yes" to 3+ questions → **Create a skill**
If you answered "yes" to 1-2 questions → **Add to CLAUDE.md**
If you answered "no" to all → **Claude already knows this**