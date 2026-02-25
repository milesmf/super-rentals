# Super Rentals — Ember.js Project Cheatsheet

This cheatsheet maps every file in your `super-rentals` project to the Ember.js
concepts it demonstrates, so you can use it as a quick reference while learning.

---

## Table of Contents

1. [What This App Does](#what-this-app-does)
2. [Project Structure at a Glance](#project-structure-at-a-glance)
3. [The Router — How Pages Are Defined](#the-router--how-pages-are-defined)
4. [Routes — Loading Data for Pages](#routes--loading-data-for-pages)
5. [Templates (.hbs) — What the User Sees](#templates-hbs--what-the-user-sees)
6. [Components (.gjs) — Reusable Building Blocks](#components-gjs--reusable-building-blocks)
7. [The Model — Defining Your Data Shape](#the-model--defining-your-data-shape)
8. [The Store Service — Fetching Data](#the-store-service--fetching-data)
9. [Static JSON API — Simulating a Backend](#static-json-api--simulating-a-backend)
10. [Key Ember Concepts Used in This Project](#key-ember-concepts-used-in-this-project)
11. [How It All Connects — Request Lifecycle](#how-it-all-connects--request-lifecycle)
12. [File-by-File Reference](#file-by-file-reference)
13. [Mapping to the Official Ember Tutorial](#mapping-to-the-official-ember-tutorial)
14. [Glossary](#glossary)

---

## What This App Does

Super Rentals is a property-rental listing site. Users can:

- **Browse** a list of rental properties on the home page (`/`)
- **View details** for a single rental (`/rentals/:rental_id`)
- **Read about** the company (`/about-us`)
- **Find contact info** (`/getting-in-touch`)
- **Toggle image size** (small ↔ large) on rental cards
- **See a map** for each property (Mapbox static images)
- **Share** a rental on Twitter

---

## Project Structure at a Glance

```
super-rentals/
├── app/
│   ├── app.js                        # Application entry point
│   ├── router.js                     # URL → Route mapping
│   ├── config/environment.js         # Runtime config loader
│   ├── deprecation-workflow.js       # Silences known deprecations
│   │
│   ├── routes/                       # Data-loading layer
│   │   ├── index.js                  #   GET all rentals
│   │   └── rental.js                 #   GET single rental
│   │
│   ├── templates/                    # Page-level Handlebars templates
│   │   ├── application.gjs           #   App shell (nav + {{outlet}})
│   │   ├── index.hbs                 #   Home page listing
│   │   ├── rental.hbs                #   Single rental page
│   │   ├── about.hbs                 #   About page
│   │   └── contact.hbs               #   Contact page
│   │
│   ├── components/                   # Reusable UI pieces
│   │   ├── nav-bar.gjs               #   Top navigation bar
│   │   ├── jumbo.gjs                 #   Hero/banner wrapper
│   │   ├── rentals.gjs               #   Rental card (list view)
│   │   ├── rentals/
│   │   │   ├── image.gjs             #   Toggleable image
│   │   │   └── detailed.gjs          #   Full detail view
│   │   ├── map.gjs                   #   Mapbox static map
│   │   └── share-button.gjs          #   Twitter share link
│   │
│   ├── models/
│   │   └── rental.js                 # Rental data model
│   │
│   ├── services/
│   │   └── store.js                  # WarpDrive/EmberData store
│   │
│   ├── utils/
│   │   └── rental.js                 # Helper to transform raw data
│   │
│   └── styles/
│       └── app.css                   # Global stylesheet
│
├── public/api/                       # Static JSON API (fake backend)
│   ├── rentals.json                  #   All rentals
│   └── rentals/
│       ├── grand-old-mansion.json    #   Individual rental
│       ├── urban-living.json
│       └── downtown-charm.json
│
├── config/
│   ├── environment.js                # Build-time config (all envs)
│   ├── optional-features.json        # Ember feature flags
│   └── targets.js                    # Browser support targets
│
├── tests/                            # Test infrastructure
│   ├── test-helper.js
│   └── helpers/index.js
│
├── ember-cli-build.js                # Build pipeline config
└── package.json                      # Dependencies & scripts
```

---

## The Router — How Pages Are Defined

**File:** `app/router.js`

```js
Router.map(function () {
  this.route('about',  { path: '/about-us' });
  this.route('contact', { path: '/getting-in-touch' });
  this.route('rental', { path: '/rentals/:rental_id' });
});
```

### What This Does

The router is the **table of contents** for your app. Each `this.route(...)` call
tells Ember: *"When the browser visits this URL, load this route."*

| Route Name | URL Pattern              | Dynamic Segment?  | Tutorial Parallel                    |
|------------|--------------------------|-------------------|--------------------------------------|
| `index`    | `/` (implicit)           | No                | Every Ember app has a default index   |
| `about`    | `/about-us`              | No                | Tutorial Part 1 — "Building Pages"   |
| `contact`  | `/getting-in-touch`      | No                | Tutorial Part 1 — "Building Pages"   |
| `rental`   | `/rentals/:rental_id`    | Yes (`:rental_id`) | Tutorial Part 2 — "Interactive Components" |

### Key Concepts

- **Implicit `index` route**: You never wrote `this.route('index')` because Ember
  creates it automatically for `/`.
- **Custom paths**: `{ path: '/about-us' }` means the route name is `about` but
  the URL is `/about-us`. Without `path`, the URL would just be `/about`.
- **Dynamic segments**: `:rental_id` is a placeholder. Visiting `/rentals/grand-old-mansion`
  sets `params.rental_id = 'grand-old-mansion'` in the route's `model()` hook.

---

## Routes — Loading Data for Pages

Routes are where you fetch data **before** the page renders.

### `app/routes/index.js` — Load All Rentals

```js
import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';

export default class IndexRoute extends Route {
  @service store;           // Inject the data store service

  async model() {
    return this.store.findAll('rental');   // → GET /api/rentals.json
  }
}
```

**Ember concept: `model()` hook** — This is the most important method on a route.
Whatever it returns becomes `@model` in the template. Ember waits for the promise
to resolve before rendering the page.

### `app/routes/rental.js` — Load One Rental

```js
export default class RentalRoute extends Route {
  @service store;

  async model(params) {
    return this.store.find('rental', params.rental_id);
    // → GET /api/rentals/grand-old-mansion.json
  }
}
```

**Key difference**: `findAll('rental')` fetches the collection; `find('rental', id)`
fetches a single record. The `params` object gives you the `:rental_id` from the URL.

### Concepts Demonstrated

| Concept              | What It Means                                                       |
|----------------------|---------------------------------------------------------------------|
| `@service store`     | Dependency injection — Ember's way of sharing singleton objects      |
| `async model()`      | Asynchronous data loading — Ember pauses rendering until resolved    |
| `findAll` / `find`   | Store methods that map to HTTP requests (JSON:API format)            |

---

## Templates (.hbs) — What the User Sees

Templates are Ember's HTML layer using **Handlebars** syntax. Each route has a
matching template.

### `app/templates/application.gjs` — The App Shell

```gjs
import { pageTitle } from 'ember-page-title';
import NavBar from '../components/nav-bar';

<template>
  {{pageTitle "SuperRentals"}}
  <NavBar />
  {{outlet}}
</template>
```

This is special — it wraps **every** page. Think of it as your `<html>` skeleton.

- `{{pageTitle "SuperRentals"}}` — Sets the browser tab title
- `<NavBar />` — Renders the nav bar on every page
- **`{{outlet}}`** — This is where child route templates get injected. When you
  visit `/about-us`, the `about.hbs` template renders inside this `{{outlet}}`.

### `app/templates/index.hbs` — Home Page

```hbs
<Jumbo>
  <h2>Welcome to Super Rentals!!!!</h2>
  <p>We hope you find exactly what you're looking for :)</p>
</Jumbo>

<div class="rentals">
  <ul class="results">
    {{#each @model as |rental|}}
      <li><Rentals @rental={{rental}} /></li>
    {{/each}}
  </ul>
</div>
```

| Syntax                          | What It Does                                              |
|---------------------------------|-----------------------------------------------------------|
| `<Jumbo>...</Jumbo>`            | Renders the `jumbo` component; content goes into `{{yield}}` |
| `@model`                        | The data returned by the route's `model()` hook           |
| `{{#each @model as \|rental\|}}` | Loop over each rental in the array                        |
| `<Rentals @rental={{rental}} />`| Render a `Rentals` component, passing the rental as an arg |

### `app/templates/rental.hbs` — Detail Page

```hbs
<Rentals::Detailed @rental={{@model}} />
```

Just one line! It delegates everything to the `Rentals::Detailed` component.
The `::` syntax means "the `detailed` component inside the `rentals/` folder."

### `app/templates/about.hbs` and `app/templates/contact.hbs`

Static content pages that use `<Jumbo>` for layout and `<LinkTo>` for navigation
between them.

```hbs
<LinkTo @route="contact" class="button">Contact Us</LinkTo>
```

**`<LinkTo>`** is Ember's replacement for `<a>` tags. It generates proper links
that use the client-side router (no full-page reload).

---

## Components (.gjs) — Reusable Building Blocks

Components are the heart of Ember Octane. Your project uses the **`.gjs`** format
(Glimmer JavaScript) which combines the class + template in a single file.

### Component Hierarchy

```
application.gjs
├── <NavBar />                 Always visible
└── {{outlet}}
    ├── index.hbs
    │   ├── <Jumbo>            Banner wrapper
    │   └── <Rentals>          One per rental in the list
    │       ├── <RentalsImage> Toggleable image
    │       └── <Map />        Mapbox static map
    │
    └── rental.hbs
        └── <Rentals::Detailed>
            ├── <Jumbo>
            ├── <ShareButton>  Twitter share link
            ├── <RentalsImage>
            └── <Map />
```

---

### `app/components/nav-bar.gjs` — Navigation Bar

```gjs
import { LinkTo } from '@ember/routing'

<template>
  <nav class="menu">
    <LinkTo @route="index" class="menu-index">
      <div class="tomster"></div>
      <h1>SuperNiceRentals</h1>
    </LinkTo>
    <div class="links">
      <LinkTo @route="about" class="menu-about">About</LinkTo>
      <LinkTo @route="contact" class="menu-contact">Contact</LinkTo>
    </div>
  </nav>
</template>
```

**Type: Template-only component** — No class, no state, just markup.
Uses `<LinkTo>` with `@route` to generate links that match your router definitions.

---

### `app/components/jumbo.gjs` — Hero Section Wrapper

```gjs
<template>
  <div class="jumbo">
    {{yield}}
  </div>
</template>
```

**Key concept: `{{yield}}`** — This is how Ember does "children" / "slots."
Whatever you put between `<Jumbo>...</Jumbo>` tags gets rendered where `{{yield}}` is.

This is called **block content** (like React's `children` prop).

---

### `app/components/rentals.gjs` — Rental Card (List View)

```gjs
import { LinkTo } from '@ember/routing';
import RentalsImage from './rentals/image';
import Map from './map';

<template>
  <article class="rental">
    <RentalsImage src={{@rental.image}} alt={{@rental.description}} />
    <div class="details">
      <LinkTo @route="rental" @model={{@rental}}>
        <h3>{{@rental.title}}</h3>
      </LinkTo>
      <div class="detail owner"><span>Owner:</span> {{@rental.owner}}</div>
      <div class="detail type"><span>Type:</span> {{@rental.type}}</div>
      <div class="detail location"><span>Location:</span> {{@rental.city}}</div>
      <div class="detail bedrooms"><span>Number of bedrooms:</span> {{@rental.bedrooms}}</div>
    </div>
    <Map @lat={{@rental.location.lat}} @lng={{@rental.location.lng}}
         @zoom="14" @width="150" @height="150" />
  </article>
</template>
```

| Pattern                              | Concept                                         |
|--------------------------------------|-------------------------------------------------|
| `@rental`                            | **Args** — data passed in from the parent       |
| `{{@rental.title}}`                  | Accessing nested properties on args              |
| `{{@rental.type}}`                   | Calls the computed `get type()` on the model     |
| `<LinkTo @model={{@rental}}>`        | Passing a model to generate the URL dynamically  |
| `<RentalsImage>`, `<Map>`            | Composing child components                       |

---

### `app/components/rentals/image.gjs` — Toggleable Image

```gjs
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';

export default class RentalsImage extends Component {
  @tracked isLarge = false;

  @action toggleSize() {
    this.isLarge = !this.isLarge;
  }

  <template>
    <button type="button"
            class="image {{if this.isLarge "large"}}"
            {{on "click" this.toggleSize}}>
      <img ...attributes>
      <small>View {{if this.isLarge "Smaller" "Larger"}}</small>
    </button>
  </template>
}
```

This is the **most concept-dense** component in the project:

| Concept               | Code                             | What It Does                                     |
|-----------------------|----------------------------------|--------------------------------------------------|
| **@tracked**          | `@tracked isLarge = false`       | Reactive state — template re-renders when changed |
| **@action**           | `@action toggleSize()`           | Marks method as safe to use in templates          |
| **{{on}} modifier**   | `{{on "click" this.toggleSize}}` | Attaches DOM event listener                       |
| **{{if}} helper**     | `{{if this.isLarge "large"}}`    | Conditional rendering in templates                |
| **...attributes**     | `<img ...attributes>`            | Splat — forwards HTML attributes from the caller  |

**`...attributes` (attribute splatting)**: When the parent does
`<RentalsImage src={{@rental.image}} alt="...">`, the `src` and `alt` are forwarded
to the `<img>` tag via `...attributes`. This is how you make components flexible.

---

### `app/components/map.gjs` — Mapbox Static Map

```gjs
import Component from '@glimmer/component';
import ENV from 'super-rentals/config/environment';

const MAPBOX_API = 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static';

export default class MapComponent extends Component {
  get token() {
    return encodeURIComponent(ENV.MAPBOX_ACCESS_TOKEN);
  }

  get mapSrc() {
    const { lng: longitude, lat: latitude, zoom, width, height } = this.args;
    const coordinates = `${longitude},${latitude},${zoom}`;
    const dimensions = `${width}x${height}`;
    const token = `access_token=${this.token}`;
    return `${MAPBOX_API}/${coordinates}/${dimensions}@2x?${token}`;
  }

  <template>
    <div class="map">
      <img alt="Map image at coordinates {{@lat}},{{@lng}}"
           ...attributes
           src="{{this.mapSrc}}"
           width={{@width}} height={{@height}} />
    </div>
  </template>
}
```

| Concept                    | Explanation                                                        |
|----------------------------|--------------------------------------------------------------------|
| **`get` (native getter)** | Computed property that recalculates when its inputs change          |
| **`this.args`**           | All arguments passed to the component as a POJO                    |
| **ENV config**            | Accessing environment config (API keys) at runtime                  |
| **Destructuring args**    | `const { lng, lat, zoom, width, height } = this.args`             |

---

### `app/components/share-button.gjs` — Twitter Share

```gjs
export default class ShareButton extends Component {
  @service router;          // Access Ember's router service

  get currentURL() {
    return new URL(this.router.currentURL, window.location.origin);
  }

  get shareURL() {
    let url = new URL('https://twitter.com/intent/tweet');
    url.searchParams.set('url', this.currentURL);
    if (this.args.text)     url.searchParams.set('text', this.args.text);
    if (this.args.hashtags) url.searchParams.set('hashtags', this.args.hashtags);
    if (this.args.via)      url.searchParams.set('via', this.args.via);
    return url;
  }

  <template>
    <a ...attributes href={{this.shareURL}}
       target="_blank" rel="external nofollow noopener noreferrer"
       class="share button">
      {{yield}}
    </a>
  </template>
}
```

| Concept                | Explanation                                                         |
|------------------------|---------------------------------------------------------------------|
| **@service router**    | Injects Ember's router to read the current URL                      |
| **`get` computed**     | Builds the share URL dynamically from args                          |
| **`{{yield}}`**        | Block content — "Share on Twitter" text passed from the parent      |
| **`...attributes`**    | Forwards any extra HTML attributes                                  |

---

## The Model — Defining Your Data Shape

**File:** `app/models/rental.js`

```js
import Model, { attr } from '@warp-drive/legacy/model';

const COMMUNITY_CATEGORIES = ['Condo', 'Townhouse', 'Apartment'];

export default class RentalModel extends Model {
  @attr title;
  @attr owner;
  @attr city;
  @attr location;      // { lat, lng } object
  @attr category;
  @attr image;
  @attr bedrooms;
  @attr description;

  get type() {
    if (COMMUNITY_CATEGORIES.includes(this.category)) {
      return 'Community';
    } else {
      return 'Standalone';
    }
  }
}
```

| Concept               | Explanation                                                          |
|-----------------------|----------------------------------------------------------------------|
| **`@attr`**           | Declares a model attribute — maps to a key in the JSON response      |
| **`get type()`**      | Computed property derived from `category` — not stored in the API    |
| **`Model` base class**| Gives your class identity (`id`), persistence, and store integration |

**How `type` works**: When `@rental.type` is accessed in a template, Ember calls
this getter. If `category` is "Condo", "Townhouse", or "Apartment", it returns
"Community"; otherwise "Standalone." This is **derived state** — computed from
existing data, not stored separately.

---

## The Store Service — Fetching Data

**File:** `app/services/store.js`

```js
import { useLegacyStore } from '@warp-drive/legacy';
import { JSONAPICache } from '@warp-drive/json-api';

const Store = useLegacyStore({
  linksMode: false,
  cache: JSONAPICache,
  handlers: [],
  schemas: [],
});

export default Store;
```

The **store** is a service (singleton) that:

1. **Manages HTTP requests** to fetch JSON:API data
2. **Caches records** so the same rental isn't fetched twice
3. **Provides `findAll()` and `find()`** methods used in your routes

Your project uses **WarpDrive** (the next-gen EmberData). In the official tutorial,
you might see `@ember-data/store` instead — same idea, newer package.

### How the Store Maps to URLs

| Store Call                           | HTTP Request                           |
|--------------------------------------|----------------------------------------|
| `this.store.findAll('rental')`       | `GET /api/rentals.json`                |
| `this.store.find('rental', 'urban-living')` | `GET /api/rentals/urban-living.json` |

---

## Static JSON API — Simulating a Backend

Instead of a real server, your app serves static JSON files from `public/api/`.

**File:** `public/api/rentals.json` (collection)

```json
{
  "data": [
    {
      "type": "rental",
      "id": "grand-old-mansion",
      "attributes": {
        "title": "Grand Old Mansion",
        "owner": "Veruca Salt",
        "city": "San Francisco",
        "location": { "lat": 37.7749, "lng": -122.4194 },
        "category": "Estate",
        "bedrooms": 15,
        "image": "https://upload.wikimedia.org/...",
        "description": "This grand old mansion sits on over 100 acres..."
      }
    },
    ...
  ]
}
```

This follows the **JSON:API specification** — the standard format that EmberData/WarpDrive
expects. Key rules:
- Top-level `"data"` key (array for collections, object for singles)
- Each record has `"type"`, `"id"`, and `"attributes"`
- The `type` must match your model name (`"rental"` → `RentalModel`)
- The `id` is used in URLs (`/rentals/grand-old-mansion`)

### Your Three Rentals

| ID                  | Title              | City          | Category  | → Computed Type |
|---------------------|--------------------|---------------|-----------|-----------------|
| `grand-old-mansion` | Grand Old Mansion  | San Francisco | Estate    | Standalone      |
| `urban-living`      | Urban Living       | Seattle       | Condo     | Community       |
| `downtown-charm`    | Downtown Charm     | Portland      | Apartment | Community       |

---

## Key Ember Concepts Used in This Project

### 1. Ember Octane Edition

Your `package.json` declares `"ember": { "edition": "octane" }`. Octane is the
modern Ember paradigm featuring:
- Native JavaScript classes (not `Ember.Object`)
- Decorators (`@tracked`, `@action`, `@service`, `@attr`)
- Glimmer components (not classic components)
- `.gjs` single-file components

### 2. `.gjs` vs `.hbs` Files

| Format | What It Is | When to Use |
|--------|-----------|-------------|
| `.hbs` | Handlebars-only template | Page templates tied to routes (no JS logic needed at the template level) |
| `.gjs` | Glimmer JS — template + class in one file | Components that need JavaScript (state, actions, computed properties) |

Your **route templates** are `.hbs` (they get data from the route, not from a class).
Your **components** are `.gjs` (they have their own logic).

Exception: `application.gjs` is a route template in `.gjs` format because it
imports `pageTitle` and `NavBar`.

### 3. Argument Passing (`@` Prefix)

```
Parent passes:     <Rentals @rental={{rental}} />
Child receives:    {{@rental.title}}  or  this.args.rental
```

The `@` prefix means "this is an argument passed by the parent." Without `@`,
you're accessing the component's own properties (`this.isLarge`).

### 4. Reactivity System

```
@tracked isLarge = false;    // Declare reactive state
this.isLarge = !this.isLarge; // Mutate it
// → Template automatically re-renders affected parts
```

Ember's **auto-tracking** system watches which `@tracked` properties each template
uses, and only re-renders when those specific values change.

### 5. Services & Dependency Injection

```js
@service store;    // Ember creates ONE store instance, shared across the app
@service router;   // Same for the router
```

Services are **singletons** — one instance for the entire app. The `@service`
decorator tells Ember to inject the right one automatically.

### 6. The `{{outlet}}` Pattern

```
application.gjs    ← always renders (nav bar)
  └── {{outlet}}   ← swapped based on URL
      ├── index.hbs     when URL is /
      ├── about.hbs     when URL is /about-us
      ├── contact.hbs   when URL is /getting-in-touch
      └── rental.hbs    when URL is /rentals/:id
```

### 7. Feature Flags (`config/optional-features.json`)

```json
{
  "application-template-wrapper": false,   // No extra <div> wrapping the app
  "default-async-observers": true,         // Observers run asynchronously
  "jquery-integration": false,             // No jQuery (modern Ember)
  "template-only-glimmer-components": true, // Components without a class are template-only
  "no-implicit-route-model": true          // Must explicitly define model() on routes
}
```

---

## How It All Connects — Request Lifecycle

Here's what happens when a user visits `/rentals/grand-old-mansion`:

```
1. Browser navigates to /rentals/grand-old-mansion
       │
2. Router matches: route('rental', { path: '/rentals/:rental_id' })
       │  params = { rental_id: 'grand-old-mansion' }
       │
3. RentalRoute.model(params) is called
       │  → this.store.find('rental', 'grand-old-mansion')
       │  → HTTP GET /api/rentals/grand-old-mansion.json
       │
4. JSON response is parsed into a RentalModel instance
       │  model.title = "Grand Old Mansion"
       │  model.type  = "Standalone" (computed from category "Estate")
       │
5. Template rental.hbs renders with @model = that RentalModel
       │  → <Rentals::Detailed @rental={{@model}} />
       │
6. Detailed component renders:
       ├── <Jumbo> with title and description
       ├── <ShareButton> with Twitter intent URL
       ├── <RentalsImage> with toggleable size
       └── <Map> with Mapbox static image URL
```

---

## File-by-File Reference

### App Infrastructure

| File | Purpose | Ember Concept |
|------|---------|---------------|
| `app/app.js` | Creates the Application instance, sets up the resolver | Application initialization |
| `app/router.js` | Maps URLs to route names | Router |
| `app/config/environment.js` | Loads runtime config from `<meta>` tags | Environment config |
| `config/environment.js` | Defines config per environment (dev/test/prod), including Mapbox token | Build-time config |
| `config/optional-features.json` | Enables/disables Ember features | Feature flags |
| `ember-cli-build.js` | Configures the build pipeline (Embroider + Vite) | Build system |

### Routes (Data Layer)

| File | What It Loads | Store Method |
|------|---------------|-------------|
| `app/routes/index.js` | All rentals for the listing page | `findAll('rental')` |
| `app/routes/rental.js` | One rental by ID for the detail page | `find('rental', id)` |

### Templates (Page Layer)

| File | URL | Content |
|------|-----|---------|
| `app/templates/application.gjs` | Every page | Nav bar + `{{outlet}}` |
| `app/templates/index.hbs` | `/` | Rental listing with `{{#each}}` loop |
| `app/templates/rental.hbs` | `/rentals/:id` | Delegates to `<Rentals::Detailed>` |
| `app/templates/about.hbs` | `/about-us` | Static about text + link to contact |
| `app/templates/contact.hbs` | `/getting-in-touch` | Address, phone, email + link to about |

### Components (UI Layer)

| File | Stateful? | Key Concepts |
|------|-----------|-------------|
| `nav-bar.gjs` | No | `<LinkTo>`, template-only component |
| `jumbo.gjs` | No | `{{yield}}` (block content) |
| `rentals.gjs` | No | Args (`@rental`), component composition, `<LinkTo @model>` |
| `rentals/image.gjs` | Yes | `@tracked`, `@action`, `{{on}}` modifier, `...attributes`, `{{if}}` |
| `rentals/detailed.gjs` | No | Component composition, sub-component imports |
| `map.gjs` | No (computed only) | `get` (native getters), `this.args`, ENV config |
| `share-button.gjs` | No (computed only) | `@service router`, `{{yield}}`, URL building |

### Data Layer

| File | Purpose |
|------|---------|
| `app/models/rental.js` | Defines the Rental model with `@attr` and a computed `type` getter |
| `app/services/store.js` | Configures WarpDrive store with JSON:API cache |
| `app/utils/rental.js` | Utility function to transform raw rental data |
| `public/api/rentals.json` | Static JSON:API response (all rentals) |
| `public/api/rentals/*.json` | Static JSON:API responses (individual rentals) |

---

## Mapping to the Official Ember Tutorial

The [official Super Rentals tutorial](https://guides.emberjs.com/release/tutorial/)
covers these same concepts. Here's how your project maps to each part:

| Tutorial Chapter | What You Built | Your Files |
|------------------|---------------|------------|
| **Part 1, Ch 1 — Orientation** | Project scaffolding, `app.js`, `router.js` | `app/app.js`, `app/router.js`, `ember-cli-build.js` |
| **Part 1, Ch 2 — Building Pages** | About & Contact pages with `<LinkTo>` | `about.hbs`, `contact.hbs`, `router.js` |
| **Part 1, Ch 3 — Automated Testing** | Test infrastructure | `tests/` |
| **Part 1, Ch 4 — Component Basics** | `<Jumbo>` wrapper with `{{yield}}` | `jumbo.gjs` |
| **Part 1, Ch 5 — More About Components** | `<NavBar>` with `<LinkTo>` navigation | `nav-bar.gjs`, `application.gjs` |
| **Part 1, Ch 6 — Interactive Components** | `<RentalsImage>` with `@tracked` + `@action` toggle | `rentals/image.gjs` |
| **Part 1, Ch 7 — Reusable Components** | `<Rentals>` card displaying rental data | `rentals.gjs` |
| **Part 1, Ch 8 — Working with Data** | Static JSON API + model hook | `public/api/`, `routes/index.js` |
| **Part 2, Ch 1 — Route Params** | Dynamic `:rental_id` segment | `routes/rental.js`, `rental.hbs` |
| **Part 2, Ch 2 — Service Injection** | `<ShareButton>` with `@service router` | `share-button.gjs` |
| **Part 2, Ch 3 — EmberData Models** | `RentalModel` with `@attr` | `models/rental.js`, `services/store.js` |
| **Part 2, Ch 4 — Provider Components** | `<Map>` with Mapbox integration | `map.gjs`, `config/environment.js` |

---

## Glossary

| Term | Definition |
|------|-----------|
| **Route** | A JavaScript class that loads data for a URL. Lives in `app/routes/`. |
| **Template** | An HTML file (`.hbs` or `.gjs`) that defines what renders for a route or component. |
| **Component** | A reusable UI element with optional state and logic. Lives in `app/components/`. |
| **Model** | A class defining the shape and behavior of a data record. Lives in `app/models/`. |
| **Service** | A singleton object shared across the app (e.g., `store`, `router`). Lives in `app/services/`. |
| **`@tracked`** | Decorator that makes a property reactive — changes trigger re-renders. |
| **`@action`** | Decorator that binds a method to the component instance for use in templates. |
| **`@service`** | Decorator that injects a service into a class. |
| **`@attr`** | Decorator that maps a model property to a JSON attribute. |
| **`{{yield}}`** | Placeholder in a component template where block content from the parent is rendered. |
| **`{{outlet}}`** | Placeholder in a route template where child route templates are rendered. |
| **`{{#each}}`** | Handlebars helper that loops over an array. |
| **`{{if}}`** | Handlebars helper for conditional rendering. |
| **`{{on}}`** | Modifier that attaches DOM event listeners. |
| **`<LinkTo>`** | Ember component that generates client-side navigation links. |
| **`...attributes`** | Forwards HTML attributes from the caller to an element inside a component. |
| **`this.args`** | Object containing all `@`-prefixed arguments passed to a component. |
| **JSON:API** | A specification for how JSON responses should be structured. Ember Data expects it. |
| **Glimmer** | The rendering engine that powers Ember's components and templates. |
| **Octane** | The modern edition of Ember (native classes, decorators, Glimmer components). |
| **Embroider** | The modern build system for Ember apps (replaces the classic build pipeline). |
| **WarpDrive** | The next-generation data layer (evolution of Ember Data). |
| **`.gjs`** | Glimmer JS file format — combines JavaScript class and template in one file. |
| **`.hbs`** | Handlebars file format — template-only, no embedded JavaScript. |
