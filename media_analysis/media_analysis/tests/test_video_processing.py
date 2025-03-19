from media_analysis.utils.video_processing import VideoProcessor


def test_extract_frames():
    frames = VideoProcessor.extract_frames("sample.mp4",4)
    assert len(frames) > 0