'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"version.json": "3d36e039ad6b7d4bde3942438c38e556",
"index.html": "25360c97b6ff98e5ca17ece9b870a5a5",
"/": "25360c97b6ff98e5ca17ece9b870a5a5",
"main.dart.js": "e04a41c57574b7678083fe6413effe07",
"flutter.js": "c71a09214cb6f5f8996a531350400a9a",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "aa4ad1f0486a01b3a987185b523c7376",
".git/config": "bbaa09bb3209580d1be3a5ec21280409",
".git/objects/61/c16548bb38528f7f21117f72bed7311aaa5cc3": "ac62df989ee684a271c958a00b7d8b77",
".git/objects/92/d9bbb69279102de9b2ce0866a0a15638cf1c9f": "98bfb9900c41a67efb2164f44f99ad2a",
".git/objects/57/532361e0f8ea0536bb61dd0f31a7eb7bfe22be": "e7db33e3e104cd6ad0b68a1869ce141e",
".git/objects/6f/9cad4c116bc8d72e2497226abb5c05ee64982c": "0d104480d68c1652a53721377a02a882",
".git/objects/04/7703418e531ad16378f0242c58a218a4401de6": "cfd15e3d454b94c204b6d8d5d7d6808a",
".git/objects/32/677c54ced8c1a20e93d3c0442c4479a7586147": "a5df106bfc7f38b2c04e6c28700d323c",
".git/objects/69/c8cac678fbeafe065d474fbfdf461bcf7abf8e": "b50c13d1e5df1ccaba09a9177ab7b415",
".git/objects/3c/cc1909e4a7027b193fcecfb5fcf3d5e1c9bbe5": "9ff0a96b418e0968f6c3fdd1d3c78dda",
".git/objects/94/bfb1463ad8331bfd687bc751b8920b133da744": "fd2d8c0d844b234856b36b93f652048f",
".git/objects/94/5f9c761e81def54d5cdc576c7215a3e33deace": "29c9817a487fbdd0a29cd4c2df888924",
".git/objects/b5/adb56ba4b6d59a4ec89b0610955ef7562cf118": "a1fe3fb325e881941acfcb321b218436",
".git/objects/b5/0254288cc6319d153c4af1d64870d95ee2436f": "468a6506934a07c970a4739eae75eedd",
".git/objects/d7/2c11112c7cb4e2ce754bc41470f9b829a2d00a": "d7280a766a5d6033f187d874a92b5ad6",
".git/objects/a5/23ee01bbb00aa0209245f93a3804ff4f266a82": "fb7a1351c560e2f221962530a3a43c0e",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/bc/3a7ba7e12edc83c094eaaefeb204b79ea4dbfb": "c82299f8b71f717d989a50a841df4727",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/e3/9747fabb60769d28bcf2837c93f1e8a2cdd2b5": "925f681c1e02f3a11b55ecb49ddf3eb7",
".git/objects/20/9f4361a2b5ddc9167b7cc2f7ad35687fd53b23": "e22f00dd9f039b266f6d86c8b418a216",
".git/objects/20/1afe538261bd7f9a38bed0524669398070d046": "82a4d6c731c1d8cdc48bce3ab3c11172",
".git/objects/18/e929d87fcdb048d98973588f241b4e2b76756f": "c8e98182610ee73948d8c573660678f0",
".git/objects/11/126ee5652834dff7ce971221e55c02c129a807": "6579f302b0e230e540aef1256f32d97d",
".git/objects/7d/9d5f347104461815e2d6b50b46d9e90b429af5": "e3f808f70101245fe1c14b8bc33f1c0e",
".git/objects/16/5ce0ddf03a820a38f48cba9aa0c9df9b6e6b79": "71df17c95c3124eada62b59e7dabda78",
".git/objects/17/e837ef166defb43fba111853707c6f0fb57612": "ed009a9baed5e287e5a14844dbc02484",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/07/74c17c0fa7a7e87e24a6935830998d92b52c75": "cd62ee54b7ceea7b2a7804e69b1d9134",
".git/objects/53/7807567919e88db2866b7825339c57e94c24d8": "970aec5149a3dbe9370a9dc982cdd022",
".git/objects/53/c95d5aca1ee312ff2614154aca04b434001b61": "4441b79d3891c684c99bb9ec3747c69e",
".git/objects/3f/4e0358938bcc04b00317759193166683f00cee": "6a6f4ee35d8ce44a9d651a9b2d26d556",
".git/objects/06/40960422ad87110ec11106bb79d18aefe69b99": "eb462e1b5d6d4e3768b46837c0717d83",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d4/8ece42999444ebc273def8d8f552c466f68c61": "4acfe27b613f08f522638bab07ec7cf2",
".git/objects/af/5884dcf820ced11a7b02500b8e9558ec7ea0ab": "ffce38a49e3a2bb140b8925bb65015c2",
".git/objects/af/742adee0a85dd21ea96cbd84182e30e085d6cf": "aa25b932ec40efacb1efe27e7cf25d82",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/ef/1ac9de151efbcf90d986116ebba1a11466ee82": "19ff55b29104c37f393b46d68c13f030",
".git/objects/e1/8a40df3b1b0eb9a61edd992104cd07bcc43495": "5f88dba8827cc39c5a9edb0b0cbbfe32",
".git/objects/cc/f0ae6bf289bc9cd63dc20b7c5b58721672cc75": "6c46a40d2ec57e166a565f65d28c3e4b",
".git/objects/e6/3e741460e6600cb0ea0d419b90238c4405212f": "11b406239c0b6f7a45f513b956a8a591",
".git/objects/e6/b745f90f2a4d1ee873fc396496c110db8ff0f3": "2933b2b2ca80c66b96cf80cd73d4cd16",
".git/objects/e6/2237b25662a116de918dc8f18e8e101625da01": "997f1ccf2f2998f6034b9b0ff3276756",
".git/objects/e8/2c5850db3a3482d0c954a4dc122c02de555ce7": "d357cd906b3805bf81477f5527cca086",
".git/objects/e8/9bc535a7b725c94db44e23e6ba74353fbf5ea0": "acfd58ce74298f2749d560c2160cc110",
".git/objects/c5/f4bc2a4da91586f3005813077f0d0aa9040f82": "3191028b787554cee4652f5050144bff",
".git/objects/2c/55000d531cb91ffb18b47e69c3ec896636c3f0": "60a99051d89e41ffd1de82aa17fda4de",
".git/objects/4a/39079e580dc9be820cba2fae41238c49eaa798": "ada1a19fea32fbb6719120809b9eae60",
".git/objects/71/7117947090611c3967f8681ab1ac0f79bca7fc": "ad4e74c0da46020e04043b5cf7f91098",
".git/objects/76/1dfaf8a6bf28d077a2943d5879567e6d4c5191": "153be257316e695fbe3f2469303b0a9b",
".git/objects/1c/47109a767e91e994f53fa228f018d7e0d7c4d4": "0c7535cf56b41cd3cd55e20518f316b3",
".git/objects/8b/9cd096d73ee0135a2c9c91900ee3c059b5f788": "9bce9baf81c7dce07e688b8a12d615df",
".git/HEAD": "cf7dd3ce51958c5f13fece957cc417fb",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "6d39a65dfc5c830240439f29bf40a871",
".git/logs/refs/heads/main": "6d39a65dfc5c830240439f29bf40a871",
".git/logs/refs/remotes/origin/main": "c3e3fd3c22cd87a8c7d6872f9edccdc7",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-commit.sample": "305eadbbcd6f6d2567e033ad12aabbc4",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/refs/heads/main": "605d80c2e2b9d417f7a6521ac6a6cbc6",
".git/refs/remotes/origin/main": "605d80c2e2b9d417f7a6521ac6a6cbc6",
".git/index": "c898ec1df0204f99135f6d1006fc962a",
".git/COMMIT_EDITMSG": "d778d8b1f42d0dd1bb284e5ca9549187",
"assets/AssetManifest.json": "c9f67e4fdf99365f294e18bd3dd8ab57",
"assets/NOTICES": "9ba95af5106a0b6156c2aaefd5fb85c5",
"assets/FontManifest.json": "88c4d131319acabb39aa01e02c9076fa",
"assets/AssetManifest.bin.json": "25b9f5c813ea3c6a7ea676bef05b2e77",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/packages/mdi/fonts/materialdesignicons-webfont.ttf": "3e722fd57a6db80ee119f0e2c230ccff",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "c7c270eaf11eb0016b1e3ea56fdceb58",
"assets/fonts/MaterialIcons-Regular.otf": "689487b01169d5a25e4bf48e27204dc2",
"assets/assets/soundBell.mp3": "ec896facb5fc6771b1f482494945c9f3",
"assets/assets/crossleLogo.png": "93ea999c5940e57e0fd017238b5f41d3",
"assets/assets/frequencyList2.txt": "999e560c60cf33e7724430ed9865eec1",
"assets/assets/soundBuzzer.mp3": "abbc4a7210400c6ac83869aaa873b4d7",
"assets/assets/crosswordMaster.txt": "6ad8911e56f9bc11a48154dc89ea251b",
"canvaskit/skwasm.js": "445e9e400085faead4493be2224d95aa",
"canvaskit/skwasm.js.symbols": "741d50ffba71f89345996b0aa8426af8",
"canvaskit/canvaskit.js.symbols": "38cba9233b92472a36ff011dc21c2c9f",
"canvaskit/skwasm.wasm": "e42815763c5d05bba43f9d0337fa7d84",
"canvaskit/chromium/canvaskit.js.symbols": "4525682ef039faeb11f24f37436dca06",
"canvaskit/chromium/canvaskit.js": "43787ac5098c648979c27c13c6f804c3",
"canvaskit/chromium/canvaskit.wasm": "f5934e694f12929ed56a671617acd254",
"canvaskit/canvaskit.js": "c86fbd9e7b17accae76e5ad116583dc4",
"canvaskit/canvaskit.wasm": "3d2a2d663e8c5111ac61a46367f751ac",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.bin.json",
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
        // Claim client to enable caching on first launch
        self.clients.claim();
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
      // Claim client to enable caching on first launch
      self.clients.claim();
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
