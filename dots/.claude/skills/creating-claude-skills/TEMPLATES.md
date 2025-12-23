# Skill Templates for Kompass

This file contains reusable templates for common skill types in this Rails event-sourced codebase.

## Template 1: Event-Sourced Feature Generation

**Use when:** Creating complete features with Command → Decider → Event → Reactor → ReadModel flow

```markdown
---
name: generating-[domain]-features
description: Generate complete event-sourced [domain] features including Commands, Deciders, Events, Reactors, and ReadModels. Use when building new [domain] functionality.
---

# Generating [Domain] Features

Create event-sourced features following the CQRS pattern for [domain] entities.

## Workflow

### 1. Define the Command

Create the command that represents user intention:

\`\`\`ruby
# app/eventing/commands/[domain]/[action].rb
module Commands
  module [Domain]
    class [Action] < Commands::Base
      attribute :entity_id, Types::String
      attribute :other_attributes, Types::Type
      attribute :metadata, CommandMetadata.optional

      validates :entity_id, :other_attributes, presence: true
    end
  end
end
\`\`\`

**Key conventions:**
- Use keyword shorthand: `Commands::[Domain]::[Action].new(entity_id:, name:)`
- All commands inherit from `Commands::Base`
- Include `CommandMetadata.optional` for tracing

### 2. Implement the Decider

Create business logic that validates and produces events:

\`\`\`ruby
# app/eventing/deciders/[domain]/[action].rb
module Deciders
  module [Domain]
    class [Action] < Deciders::Base
      def call(command)
        # Load current state
        entity = load_entity(command.entity_id)

        # Validate
        return Failure(reason: :not_found) unless entity
        return noop if already_done?(entity)

        # Produce event
        event = Events::[Domain]::[EventName].new(
          entity_id: command.entity_id,
          # Use keyword shorthand for all attributes
          attribute_name: command.attribute_name,
          valid_at: command.metadata&.valid_at || Time.current
        )

        Success(event)
      end

      private

      def load_entity(id)
        # Load from repository
      end

      def already_done?(entity)
        # Check if action already completed
      end
    end
  end
end
\`\`\`

**Key patterns:**
- Return `Success(event)`, `Failure(reason:)`, or `noop`
- Load current state for validation
- Check noop conditions
- Set `valid_at` from metadata or current time

### 3. Define the Event

Create immutable event representing what happened:

\`\`\`ruby
# app/eventing/events/[domain]/[event_name].rb
module Events
  module [Domain]
    class [EventName] < Events::Base
      attribute :entity_id, Types::String
      attribute :other_data, Types::Type

      validates :entity_id, :other_data, presence: true
    end
  end
end
\`\`\`

**Key conventions:**
- Events are immutable facts (past tense names)
- Include all data needed by reactors
- Validate required attributes

### 4. Create Reactors for Side Effects

Update read models and trigger other actions:

\`\`\`ruby
# app/eventing/reactors/[domain]/[event_name]_reactor.rb
module Reactors
  module [Domain]
    class [EventName]Reactor < Reactors::Base
      subscribes_to Events::[Domain]::[EventName]

      def call(event)
        # Update read model
        ReadModels::[Domain]::[Entity].upsert(
          {
            id: event.entity_id,
            attribute: event.attribute,
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

**Key patterns:**
- Use `subscribes_to` to register event handlers
- Update read models with temporal data (valid_from/valid_to)
- Return `Success()` for successful processing

### 5. Define Read Model

Create Active Record model for queries:

\`\`\`ruby
# app/eventing/read_models/[domain]/[entity].rb
module ReadModels
  module [Domain]
    class [Entity] < ReadModels::Base
      self.table_name = "[domain]_[entities]"

      # Associations
      belongs_to :related_entity

      # Scopes
      scope :active, -> { where(valid_to: nil) }
      scope :as_of, ->(timestamp) {
        where("valid_from <= ?", timestamp)
          .where("valid_to IS NULL OR valid_to > ?", timestamp)
      }
    end
  end
end
\`\`\`

### 6. Create Repository

Provide domain queries:

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

## Testing Checklist

- [ ] Decider spec tests successful event creation
- [ ] Decider spec tests validation failures
- [ ] Decider spec tests noop conditions
- [ ] Reactor spec tests read model updates
- [ ] Integration spec tests full command flow
- [ ] Repository spec tests temporal queries

## Domain-Specific Customizations

[Add any domain-specific patterns, validations, or business rules here]
```

---

## Template 2: Testing Pattern Skills

**Use when:** Defining specific testing approaches for domain components

```markdown
---
name: testing-[component-type]
description: Write behavior-focused RSpec tests for [component type]. Use when creating test coverage for [when to use].
---

# Testing [Component Type]

Write focused, behavior-driven tests for [component type] that validate business logic without testing implementation details.

## Core Testing Philosophy

**Test BEHAVIOR, not IMPLEMENTATION:**
- ✅ Test the right event is created with correct data
- ✅ Test validation failures return proper error messages
- ✅ Test noop scenarios
- ✅ Test edge cases from business requirements
- ❌ DO NOT test inheritance (derives from base classes)
- ❌ DO NOT test method existence (respond_to?)
- ❌ DO NOT test internal implementation details

## Test Structure

\`\`\`ruby
RSpec.describe [ComponentClass] do
  describe "successful scenarios" do
    it "creates correct event with expected data" do
      command = Commands::[Domain]::[Action].new(
        entity_id:,
        attribute:
      )

      result = described_class.call(command)

      expect(result).to be_success
      event = result.success
      expect(event.entity_id).to eq(entity_id)
      expect(event.attribute).to eq(expected_value)
    end
  end

  describe "noop scenarios" do
    it "returns noop when no action needed" do
      # Setup condition where action already done

      result = described_class.call(command)

      expect(result).to be_noop
    end
  end

  describe "validation failures" do
    it "fails with descriptive error for invalid input" do
      command = Commands::[Domain]::[Action].new(
        entity_id:,
        invalid_attribute: bad_value
      )

      result = described_class.call(command)

      expect(result).to be_failure.with(
        reason: :invalid,
        errors: [ValidationError.new(:field, :error_type)]
      )
    end
  end
end
\`\`\`

## Key Patterns

- Use `be_success`, `be_failure`, `be_noop` matchers
- Access event via `result.success`
- Test actual data values, not just presence
- Group by scenario type (success/noop/failure)

## What NOT to Test

\`\`\`ruby
# ❌ BAD - Tests implementation
it "derives from Deciders::Base" do
  expect(described_class.ancestors).to include(Deciders::Base)
end

# ❌ BAD - Tests method existence
it "responds to call" do
  expect(described_class).to respond_to(:call)
end

# ✅ GOOD - Tests behavior
it "creates event with correct data" do
  result = described_class.call(command)
  expect(result.success.entity_id).to eq(expected_id)
end
\`\`\`
```

---

## Template 3: Workflow/Process Skills

**Use when:** Multi-step processes with validation loops

```markdown
---
name: [action]-[domain-objects]
description: [Action description with multiple steps]. Use when [specific trigger condition].
---

# [Action] [Domain Objects]

[Brief overview of the workflow]

## Prerequisites

- [ ] Prerequisite 1
- [ ] Prerequisite 2
- [ ] Required data available

## Workflow

### Step 1: [Action Name]

[What to do in this step]

\`\`\`bash
bin/rails generate [generator_name] [args]
\`\`\`

**Validation:**
\`\`\`bash
bundle exec rspec spec/path/to/spec
\`\`\`

Expected output: [What success looks like]

### Step 2: [Next Action]

[What to do]

**Key conventions:**
- Use keyword shorthand: `method(param:)`
- Use `bin/rails` not `rails`

**Validation:**
- [ ] Check 1
- [ ] Check 2

### Step 3: [Final Action]

[Completion steps]

## Validation Loop

After each step:
1. Run tests: `bundle exec rspec [relevant specs]`
2. If failures, fix errors
3. Re-run until green
4. Proceed to next step

## Final Checklist

- [ ] All tests passing
- [ ] Code follows conventions
- [ ] Documentation updated if needed
- [ ] [Domain-specific check]

## Common Issues

**Issue:** [Common problem]
**Solution:** [How to fix]

**Issue:** [Another problem]
**Solution:** [Resolution steps]
```

---

## Template 4: Code Generation Skills

**Use when:** Generating boilerplate following specific patterns

```markdown
---
name: generating-[component-type]
description: Generate [component type] with proper structure and boilerplate. Use when creating new [component types].
---

# Generating [Component Type]

Generate [component type] following codebase conventions.

## Quick Reference

**File location:** `app/[directory]/[domain]/[file_name].rb`

**Naming convention:** [Explanation of naming]

## Generation Steps

### 1. Create the File

\`\`\`ruby
# app/[directory]/[domain]/[file_name].rb
module [Module]
  module [Domain]
    class [ClassName] < [BaseClass]
      # Structure
    end
  end
end
\`\`\`

### 2. Add Required Attributes/Methods

\`\`\`ruby
attribute :required_field, Types::String
attribute :optional_field, Types::String.optional

validates :required_field, presence: true
\`\`\`

**Key conventions:**
- Use keyword shorthand in method calls
- Follow naming patterns from existing code
- Include necessary validations

### 3. Add Tests

\`\`\`ruby
RSpec.describe [Module]::[Domain]::[ClassName] do
  describe "behavior 1" do
    it "does expected thing" do
      # Test
    end
  end
end
\`\`\`

### 4. Validate

\`\`\`bash
bundle exec rspec spec/[path]
bin/rubocop app/[path]
\`\`\`

## Examples

[Concrete examples from codebase]

## Validation Checklist

- [ ] File in correct location
- [ ] Follows naming conventions
- [ ] Includes required attributes
- [ ] Has test coverage
- [ ] Passes linting
```

---

## Choosing the Right Template

1. **Event-Sourced Feature** - Full CQRS flow with multiple components
2. **Testing Pattern** - Specific testing approach for component type
3. **Workflow/Process** - Multi-step coordinated process
4. **Code Generation** - Creating structured boilerplate

**Selection criteria:**
- If it involves Commands/Events/Reactors → Template 1
- If it's about testing approach → Template 2
- If it has validation loops and multiple steps → Template 3
- If it's generating specific file types → Template 4

## Customization Guidelines

When adapting templates:

1. **Replace placeholders:** [Domain], [Action], [Entity], etc.
2. **Add domain-specific patterns:** Business rules, validations
3. **Include real examples:** From actual codebase
4. **Keep it concise:** Remove unnecessary sections
5. **Add validation steps:** Specific to your workflow

Remember: Templates are starting points. Customize based on actual patterns in your codebase.