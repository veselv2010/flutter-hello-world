library constants;

const String CLIENT_ID = "2263e08fecb040ffbbaa47fbb867972a";
const String CLIENT_SECRET = "197776909380429dac9d7263317b6811";

const String SCOPES =
    "ugc-image-upload playlist-read-collaborative playlist-modify-private playlist-modify-public " +
        "playlist-read-private user-library-read user-read-playback-state user-read-playback-position " +
        "user-read-recently-played user-top-read user-modify-playback-state user-read-currently-playing " +
        "user-read-private user-read-email user-read-private user-read-email user-library-modify user-follow-modify user-follow-read streaming app-remote-control";

const String REDIRECT_URI = "https://blank.org/";
const String ACCESS_TOKEN_ENDPOINT = "https://accounts.spotify.com/api/token";
const String SAVED_TRACKS_ENDPOINT = "https://api.spotify.com/v1/me/tracks";
const String CURRENT_PLAYBACK_ENDPOINT = "https://api.spotify.com/v1/me/player";
const String PLAYER_NEXT_ENDPOINT = "https://api.spotify.com/v1/me/player/next";
const String PLAYER_PREV_ENDPOINT =
    "https://api.spotify.com/v1/me/player/previous";
const String PLAYER_PAUSE_ENDPOINT =
    "https://api.spotify.com/v1/me/player/pause";
const String PLAYER_RESUME_ENDPOINT =
    "https://api.spotify.com/v1/me/player/play";
const String AUTH_URL =
    "https://accounts.spotify.com/authorize?client_id=$CLIENT_ID&response_type=code&redirect_uri=$REDIRECT_URI&state=fdsfdsfds&scope=$SCOPES&show_dialog=true/";

String accessToken = "";
