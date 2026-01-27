allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ✅ مهم جدًا: خلّي كل مخرجات build تروح للـ root build folder (../build)
// ده اللي Flutter بيعتمد عليه عشان يلاقي الـ APK
val newBuildDir = rootProject.layout.projectDirectory.dir("../build")
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val subprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(subprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
