'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"index.html": "8400b4829c60d46eac163d26aee35d0f",
"/": "8400b4829c60d46eac163d26aee35d0f",
"manifest.json": "b06940cea072a85bf99b91760be964c1",
"version.json": "73178d81dcb591deb7aa32b222071438",
"main.dart.js": "776cd9bf2ad020bcc1fb892ca4be0be7",
"assets/FontManifest.json": "ee4cd7c80b614c214c6b8273584115f1",
"assets/NOTICES": "47b210ebdb4826abba6e9f8ef8536437",
"assets/AssetManifest.json": "e22a1293da6e4086b6de6f2d925e190d",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"assets/assets/Pic%25202.png": "ccd15e00b5c86ac6238a339b6472fd7a",
"assets/assets/icon14.png": "679661a096670448296d14414c6afe22",
"assets/assets/icon5.png": "7e7f8c183bd6db26b25e6b0fbbf49b18",
"assets/assets/icon7.png": "3472904bbfc1ad29edb2fba9b9a1ddb1",
"assets/assets/icon19.png": "29bb0b918ab8aef05f25d13a0dc9f8e9",
"assets/assets/icon21.png": "f0cc557bda9588a2b6c2417c4fc84829",
"assets/assets/icon18.png": "88806dee2ca6ba3501da697fc9aa3c05",
"assets/assets/icon8.png": "5fd06b5c0cfd76fd30906238ce7cdd3e",
"assets/assets/101.png": "ea9735c7f24bf8f759e0bf7d52144efa",
"assets/assets/icon32.png": "47f5a09c00ad864f03cf07b080282dd1",
"assets/assets/icon25.png": "a3e3f502c160e9dfe0e675c54d556363",
"assets/assets/icon33.png": "03fa5a9d425ee3f63a2dd9f3c13db13b",
"assets/assets/icon6.png": "1d24a352c871cdeb0346b3145bec8c96",
"assets/assets/icon17.png": "25149c996860e0b6a7dca45399ce5b9c",
"assets/assets/icon1.png": "23768a1004cbb11dbe847ae40e4dccbf",
"assets/assets/icon30.png": "14d40a2f172ae8ea9cae9ab5f65be6b0",
"assets/assets/Pic%25201.png": "a98fb6895a6fa35d979f42191bbe294f",
"assets/assets/Picture3.png": "dfa0bbf157693e0ef64807262d4073bb",
"assets/assets/icon31.png": "3b449be4ec42196d560e3e263d1e1636",
"assets/assets/icon20.png": "20638359e39e86d28c3d456410d7a4e2",
"assets/assets/Pic%25205.png": "8862ca842a414274f054971848bc3655",
"assets/assets/icon12.png": "ca5bbbe5420e3ef0f0b0a55157bfeceb",
"assets/assets/icon4.png": "02c6074529032ae759328cf2939100e9",
"assets/assets/Pic_202.png": "ccd15e00b5c86ac6238a339b6472fd7a",
"assets/assets/icon24.png": "5679b7353488b91f13bf314301381644",
"assets/assets/icon3.png": "ae17ff5989dd72fd6c749f5067e252b5",
"assets/assets/Pic%25203.png": "42fa99c5b798272fca35b2e6a20f7faf",
"assets/assets/Lato/Lato-Bold.ttf": "85d339d916479f729938d2911b85bf1f",
"assets/assets/Lato/Lato-Regular.ttf": "2d36b1a925432bae7f3c53a340868c6e",
"assets/assets/Picture1BW.png": "8493ba4757bc11d43623b2587bf4d86b",
"assets/assets/icon10.png": "da0286399274af391343e8c9f1b492d3",
"assets/assets/icon13.png": "185700b51d910b9e55100658de70d0ae",
"assets/assets/background.jpg": "9e22d11b04fa776966adb68ffe45bb3a",
"assets/assets/icon2.png": "0c207925076f28e9f5e4cb9d16c0f625",
"assets/assets/Pic_204.png": "78fed9d38bad7201f7c466fd47c07556",
"assets/assets/icon28.png": "c917923282a341f31430c4510450b712",
"assets/assets/icon15.png": "ea4484b8fd70a1ab98aa1844f3fe352d",
"assets/assets/icon29.png": "6eeb007d1cb91d9d50dc45fcbc04951b",
"assets/assets/Picture2BW.png": "3752d54dc7fb074de12819e3fe26b475",
"assets/assets/mahindraAppBarLogo.png": "8378c52f48d43fd086352f006a2bf651",
"assets/assets/icon23.png": "87f582294136b1ff202be19da5e33792",
"assets/assets/Pic_201.png": "a98fb6895a6fa35d979f42191bbe294f",
"assets/assets/icon27.png": "6488eadc2cb0f14a31f69ffdd928d167",
"assets/assets/Picture2.png": "97eab8a5c34becf03a863ce5ecc17eeb",
"assets/assets/icon11.png": "e21ba595c999873aee74420861dcb91b",
"assets/assets/Pic_203.png": "42fa99c5b798272fca35b2e6a20f7faf",
"assets/assets/icon16.png": "5bbb01cfb7c1e1eb8059bff7f32bbd99",
"assets/assets/icon9.png": "a2d6da4a8a3b495c271bec8ecb1e9b2d",
"assets/assets/Picture1.png": "2981a604d8e6fb25ab33019420cc5cdf",
"assets/assets/TMSW.png": "3989ebe5c4e73fd8f3cb3360320bc971",
"assets/assets/mahindraAppBar.png": "087790fa2e4dc2e4da6629e56e02e37e",
"assets/assets/icon26.png": "45680e05971a6f3c4f77eff3ca355f4d",
"assets/assets/Pic_205.png": "8862ca842a414274f054971848bc3655",
"assets/assets/icon22.png": "71172442044a97f9c6d06f266832b26f",
"assets/assets/Pic%25204.png": "78fed9d38bad7201f7c466fd47c07556",
"assets/fonts/MaterialIcons-Regular.otf": "4e6447691c9509f7acdbf8a931a85ca1",
"favicon.png": "d31106f279f862ff0c8384bfeee7b9cf"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
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
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
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
