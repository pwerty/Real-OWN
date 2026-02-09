using UnityEditor;

public class BuildScript
{
    // Linux Server 빌드 (Jenkins 파이프라인에서 사용)
    public static void BuildLinuxServer()
    {
        BuildPlayerOptions options = new BuildPlayerOptions();
        options.scenes = new[] { "Assets/Scenes/SampleScene.unity" };
        options.locationPathName = "Builds/Linux/ElysianForest.x86_64";
        options.target = BuildTarget.StandaloneLinux64;
        options.options = BuildOptions.None;
        
        BuildPipeline.BuildPlayer(options);
    }

    // ========== 기존 Windows 빌드 (주석 처리) ==========
    // public static void BuildWindowsClient()
    // {
    //     string[] scenes = { "Assets/Scenes/SampleScene.unity" }; 
    //     // 경로를 .exe 파일로 지정합니다.
    //     BuildPipeline.BuildPlayer(scenes, "Builds/Windows/Game.exe", 
    //         BuildTarget.StandaloneWindows64, BuildOptions.None);
    // }
}