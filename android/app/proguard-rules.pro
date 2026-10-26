# Firebase discovers ComponentRegistrar classes by name from the manifest and
# instantiates them reflectively via their no-arg constructor. firebase-components'
# consumer rule keeps only the class, so R8 (AGP 9) strips the constructor and the
# registrar silently fails to load (e.g. "FirebaseCrashlytics component is not present").
-keep class * implements com.google.firebase.components.ComponentRegistrar {
    public <init>();
}
