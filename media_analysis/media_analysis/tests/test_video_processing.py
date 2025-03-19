from media_analysis.utils.video_processing import VideoProcessor

def get_absolute_path(filename):
    dir_path = "/Users/macbookpro/Desktop/hackathon/media_analysis/media_analysis/data"
    return f"{dir_path}/{filename}"

def test_extract_frames():
    frames = VideoProcessor().extract_frames(get_absolute_path("sample.mp4"),4)
    assert len(frames) > 0


