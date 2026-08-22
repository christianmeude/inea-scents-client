enum Environment { local, live }

/// Toggle this to `Environment.live` to point to the live Render backend while testing in Debug mode.
/// Note: In Release mode, this setting is ignored and the app will always point to the live backend.
const Environment currentEnvironment = Environment.local;
