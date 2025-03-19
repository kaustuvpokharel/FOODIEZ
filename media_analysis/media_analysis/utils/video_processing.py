import cv2
from typing import List

class VideoProcessor:
    """
    Class for utilities regarding video processing
    """
    def __init__(self) -> None:
        pass

    def extract_frames(video_path, frame_rate = 1) -> List[int] :
        frames = []
        cap = cv2.VideoCapture(video_path)
        fps = cap.get(cv2.CAP_PROP_FPS)
        frame_interval = int(fps / frame_rate)
        frame_count = 0

        while cap.isOpened():
            #ret = succes_val, frame = image
            ret, frame = cap.read()
            if not ret:
                break
            if frame_count % frame_interval == 0:
                frames.append(frame)
            # cv2.imwrite(f"current{frame_count}.jpeg",frame)
            frame_count += 1

        cap.release()
        return frames
