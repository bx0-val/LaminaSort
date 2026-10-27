# Bedrock 26.60 port investigation

Status: not ported; do not install the 26.51 binaries as a 26.60 build.

## Exact client examined

- Installed package: `Microsoft.MinecraftUWP_1.26.6005.0_x64__8wekyb3d8bbwe`.
- A read-only copy of the executable was obtained using Windows' package
  execution interface. Its SHA-256 is
  `988f6a61403b4381aa41e6c66d64cce441b14e561a9b10f647c2758ef3f2672a`.
- The checked upstream LeviLamina version database ends at 1.26.51.01,
  and the latest client runtime data is `26.51.1-client.12`.
- LaminaSort v0.1.0 directly delay-imports 22 functions/symbols from
  `bedrock_runtime.dll`, including ContainerManagerController methods,
  ContainerScreenController hooks, ItemStack constructors, comparisons, and
  stack limits. It also imports 33 LeviLamina DLL functions and uses generated
  C++ class layouts. It is not enough to update a manifest or recompile the
  same headers.
- The published PreLoader repository says PreLoader has been closed source
  since v1.10.0. The published client runtime-data repository currently
  contains distribution metadata, not the source symbol dataset or generator.

## Investigation performed

Using BedrockDynamicSDK's cross-version anchor tool, scanned the exact 26.60
executable against its published 26.52.3 profile. Nine symbols produced
candidate matches, all marked ABI-unverified. The only ItemStack-related match
was `ItemStackBase::getHoverName`, which is not one of the 22 delayed imports
needed by LaminaSort. Several input and world-event matches were missing or
ambiguous. The tool did not port inventory layouts.

The candidate `Level::getRuntimeActorList` changed an object-field access from
`+0x4b0` in the old 26.52 signature to `+0x4b8` in the 26.60 match. This is
evidence of layout drift in one candidate, not proof of the chest layout.
The separate RTTI scan identified 1,906 type names; it did not supply the
required container methods or verify the relevant field offsets.

Local evidence (not checked into the repository):

- `../candidate-26.60.json`: generated candidates and diagnostics.
- `../rtti-26.60.json`: RTTI type scan.
- `../Minecraft-1.26.60.exe`: local licensed executable copy; do not publish.

## Remaining work

Obtain or independently derive exact-build addresses for the 22 imports and
the loader's own symbols; establish the matching item, container, screen and
registry layouts; implement or adapt a resolver/loader for those addresses;
rebuild the DLL against verified definitions; then test normal and partial
stack moves, metadata preservation, chest variants, server responses and
rollback in a disposable world. Candidate pattern matches alone do not verify
function signatures, calling convention, object fields, or safe item moves.
