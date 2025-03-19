import cv2
import numpy as np
from typing import List

class VideoProcessor:
    """
    Class for utilities regarding video processing
    """
    def __init__(self) -> None:
        pass

    def extract_frames(self,video_path, frame_rate = 1) -> List[np.ndarray]:
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
        cv2.destroyAllWindows() 
        return frames
    
    
# frame_rate = 1, length = 31
# frame_rate = 2, length = 63
# frame_rate = 3, length = 99
# frame_rate = 4, length = 139
# frame_rate = 5, length = 174
# frame_rate = 6, length = 231
# frame_rate = 7, length = 231
# frame_rate = 8, length = 347
# frame_rate = 9, length = 347
# frame_rate = 10, length = 347
# frame_rate = 11, length = 347
# frame_rate = 12, length = 693
# frame_rate = 13, length = 693
# frame_rate = 14, length = 693
# frame_rate = 15, length = 693
# frame_rate = 16, length = 693
# frame_rate = 17, length = 693
# frame_rate = 18, length = 693
# frame_rate = 19, length = 693