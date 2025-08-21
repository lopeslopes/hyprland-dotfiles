import qs.modules.common
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
pragma Singleton
pragma ComponentBehavior: Bound

/**
 * A nice wrapper for default Pipewire audio sink and source.
 */
Singleton {
    id: root

    property bool ready: Pipewire.defaultAudioSink?.ready ?? false
    property PwNode sink: Pipewire.defaultAudioSink
    property PwNode source: Pipewire.defaultAudioSource

    signal sinkProtectionTriggered(string reason);

    PwObjectTracker {
        objects: [sink, source]
    }

    // Debug logs
    Component.onCompleted: {
        console.log("=== Audio.qml Debug Start ===")
        console.log("Default Pipewire sink:", sink ? sink.name : "null")
        console.log("Default Pipewire source:", source ? source.name : "null")
        console.log("Sink ready?", sink ? sink.ready : "null")
        console.log("Source ready?", source ? source.ready : "null")
    }

    Connections {
        target: sink ?? null
        onReadyChanged: console.log("[Sink] ready changed:", sink.ready, "name:", sink.name)
    }

    Connections {
        target: source ?? null
        onReadyChanged: console.log("[Source] ready changed:", source.ready, "name:", source.name)
    }

    Connections { // Protection against sudden volume changes
        target: sink?.audio ?? null
        property bool lastReady: false
        property real lastVolume: 0
        function onVolumeChanged() {
            console.log("[Sink] volume changed:", sink.audio.volume)

            if (!Config.options.audio.protection.enable) return;
            if (!lastReady) {
                lastVolume = sink.audio.volume;
                lastReady = true;
                return;
            }
            const newVolume = sink.audio.volume;
            const maxAllowedIncrease = Config.options.audio.protection.maxAllowedIncrease / 100; 
            const maxAllowed = Config.options.audio.protection.maxAllowed / 100;

            if (newVolume - lastVolume > maxAllowedIncrease) {
                sink.audio.volume = lastVolume;
                root.sinkProtectionTriggered("Illegal increment");
            } else if (newVolume > maxAllowed) {
                root.sinkProtectionTriggered("Exceeded max allowed");
                sink.audio.volume = Math.min(lastVolume, maxAllowed);
            }
            if (sink.ready && (isNaN(sink.audio.volume) || sink.audio.volume === undefined || sink.audio.volume === null)) {
                sink.audio.volume = 0;
            }
            lastVolume = sink.audio.volume;
        }
    }
}




// import qs.modules.common
// import QtQuick
// import Quickshell
// import Quickshell.Services.Pipewire
// pragma Singleton
// pragma ComponentBehavior: Bound
//
// /**
//  * A nice wrapper for default Pipewire audio sink and source.
//  */
// Singleton {
//     id: root
//
//     property bool ready: Pipewire.defaultAudioSink?.ready ?? false
//     property PwNode sink: Pipewire.defaultAudioSink
//     property PwNode source: Pipewire.defaultAudioSource
//
//     signal sinkProtectionTriggered(string reason);
//
//     PwObjectTracker {
//         objects: [sink, source]
//     }
//
//     Connections { // Protection against sudden volume changes
//         target: sink?.audio ?? null
//         property bool lastReady: false
//         property real lastVolume: 0
//         function onVolumeChanged() {
//             if (!Config.options.audio.protection.enable) return;
//             if (!lastReady) {
//                 lastVolume = sink.audio.volume;
//                 lastReady = true;
//                 return;
//             }
//             const newVolume = sink.audio.volume;
//             const maxAllowedIncrease = Config.options.audio.protection.maxAllowedIncrease / 100; 
//             const maxAllowed = Config.options.audio.protection.maxAllowed / 100;
//
//             if (newVolume - lastVolume > maxAllowedIncrease) {
//                 sink.audio.volume = lastVolume;
//                 root.sinkProtectionTriggered("Illegal increment");
//             } else if (newVolume > maxAllowed) {
//                 root.sinkProtectionTriggered("Exceeded max allowed");
//                 sink.audio.volume = Math.min(lastVolume, maxAllowed);
//             }
//             if (sink.ready && (isNaN(sink.audio.volume) || sink.audio.volume === undefined || sink.audio.volume === null)) {
//                 sink.audio.volume = 0;
//             }
//             lastVolume = sink.audio.volume;
//         }
//
//     }
//
// }
