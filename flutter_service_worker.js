'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "splash/style.css": "9816952fd684c9ab5e58d66bf8a82a64",
"splash/img/branding-dark-1x.png": "c591c17cba92cfb2a3815a8695d138f3",
"splash/img/dark-1x.png": "c591c17cba92cfb2a3815a8695d138f3",
"splash/img/branding-dark-2x.png": "1c24f43175fc749aad8a02a2fff9fdcb",
"splash/img/branding-dark-3x.png": "006ecff626c21822b742dfe6775e5cc9",
"splash/img/dark-2x.png": "1c24f43175fc749aad8a02a2fff9fdcb",
"splash/img/light-4x.png": "d14d611b24ce903c9cb962313684db13",
"splash/img/light-3x.png": "006ecff626c21822b742dfe6775e5cc9",
"splash/img/dark-3x.png": "006ecff626c21822b742dfe6775e5cc9",
"splash/img/light-2x.png": "1c24f43175fc749aad8a02a2fff9fdcb",
"splash/img/branding-3x.png": "006ecff626c21822b742dfe6775e5cc9",
"splash/img/branding-2x.png": "1c24f43175fc749aad8a02a2fff9fdcb",
"splash/img/light-1x.png": "c591c17cba92cfb2a3815a8695d138f3",
"splash/img/dark-4x.png": "d14d611b24ce903c9cb962313684db13",
"splash/img/branding-dark-4x.png": "d14d611b24ce903c9cb962313684db13",
"splash/img/branding-4x.png": "d14d611b24ce903c9cb962313684db13",
"splash/img/branding-1x.png": "c591c17cba92cfb2a3815a8695d138f3",
"splash/splash.js": "123c400b58bea74c1305ca3ac966748d",
"version.json": "a60c0bbdc4f22cafd28eaecba23bab76",
"canvaskit/canvaskit.wasm": "bf50631470eb967688cca13ee181af62",
"canvaskit/canvaskit.js": "2bc454a691c631b07a9307ac4ca47797",
"canvaskit/profiling/canvaskit.wasm": "95a45378b69e77af5ed2bc72b2209b94",
"canvaskit/profiling/canvaskit.js": "38164e5a72bdad0faa4ce740c9b8e564",
"favicon.png": "f407a46ac6942a73d5092b84389befb8",
"flutter.js": "f85e6fb278b0fd20c349186fb46ae36d",
"index.html": "0c6917effbb9c57f44463903427bd59e",
"/": "0c6917effbb9c57f44463903427bd59e",
"manifest.json": "d41d8cd98f00b204e9800998ecf8427e",
"main.dart.js": "94205a4bb3a9aa9291fa2f0cf0769811",
"assets/AssetManifest.json": "4531d9e650aaa330d1cb82d16a840eb5",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/NOTICES": "f0684ec0e49cb94f5be4511fe5f50fdb",
"assets/fonts/MaterialIcons-Regular.otf": "95db9098c58fd6db106f1116bae85a0b",
"assets/assets/riv/robot.riv": "2f0c89e6e837e2098aec8d8bea396b63",
"assets/assets/riv/background.riv": "bd0fd9bfc52ff1bba8cb20513e3d1b6f",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/shaders/ink_sparkle.frag": "1ed03b0025463b56a87ebe9d27588c8a",
"icons/Icon-maskable-192.png": "2d77f94c34f9cd62afa89a9f2faf22b8",
"icons/Icon-maskable-512.png": "c963f0ac99ab629379aa8ac613a7b3f0",
"icons/Icon-192.png": "2d77f94c34f9cd62afa89a9f2faf22b8",
"icons/Icon-512.png": "c963f0ac99ab629379aa8ac613a7b3f0"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
