
from media_analysis.utils.video_processing import VideoProcessor


class MediaAnalyzer:
    def __init__(self, video_path):
        #model
        self.model = None
        self.video_path = video_path
        self.frame_rate = 3
        self.frames = VideoProcessor().extract_frames(video_path, self.frame_rate)
        if len(self.frames) == 0:
            raise ValueError("Video frames has no frames or frames cannot be extracted")

    def analyze_frames(self):
        
        results = self.model(self.frames, self.frame_rate)  # return a generator of Results objects
        pass


if __name__=='__main__':
    dir_path = "/Users/macbookpro/Desktop/hackathon/media_analysis/media_analysis/data"
    vid_analyzer = MediaAnalyzer(f"{dir_path}/sample.mp4")
    vid_analyzer.analyze_frames()
    
