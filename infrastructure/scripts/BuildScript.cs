using UnityEditor;

public static class BuildScript
{
    public static void BuildWindowsClient()
    {
        string[] scenes = { "Assets/Scenes/SampleScene.unity" }; 
        // 경로를 .exe 파일로 지정합니다.
        BuildPipeline.BuildPlayer(scenes, "Builds/Windows/Game.exe", 
            BuildTarget.StandaloneWindows64, BuildOptions.None);
    }
}