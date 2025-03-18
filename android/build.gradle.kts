allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // Garante que todos os subprojetos dependam do projeto :app
    project.evaluationDependsOn(":app")
}

// Tarefa de limpeza para excluir o diretório de build
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
