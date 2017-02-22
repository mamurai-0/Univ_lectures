import csv
import numpy as np
from matplotlib import pyplot as plt
from matplotlib import animation
plt.rcParams['animation.ffmpeg_path'] = '/usr/local/bin/ffmpeg'

# ファイル読み込み
f = open("4.out", "r")
reader = csv.reader(f)

cor_x1 = []
cor_y1 = []
cor_x2 = []
cor_y2 = []
for row in reader:
    cor_x1.append(float(row[0]))
    cor_y1.append(float(row[1]))
    cor_x2.append(float(row[2]))
    cor_y2.append(float(row[3]))
f.close()

# プロットするものの準備
fig = plt.figure()
ax = plt.axes(xlim=(-10, 10), ylim=(-10, 10))
earth = plt.Circle((1, 0), 0.1, fc='b')
sun = plt.Circle((0, 0), 0.2, fc='r')
time_text = ax.text(0.05, 0.9, 't=0', transform=ax.transAxes)
plt.gca().set_aspect('equal', adjustable='box')

# 初期化
def init():
    earth.center = (cor_x1[0], cor_y1[0])
    sun.center = (cor_x2[0], cor_y2[0])
    ax.add_patch(earth)
    ax.add_patch(sun)
    return earth,sun

# アニメーション描画
def animate(i):
    # 50回に1回だけ表示
    earth.center = (cor_x1[i*50], cor_y1[i*50])
    sun.center = (cor_x2[i*50], cor_y2[i*50])
    time_text.set_text("t={}".format(i*50))
    return earth,sun

# 軌道の表示
plt.plot(cor_x1, cor_y1, 'k')
plt.plot(cor_x2, cor_y2, 'k')
# アニメーション
anim = animation.FuncAnimation(fig, animate,
                               init_func=init,
                               frames=200,
                               interval=50,
                               blit=False,
                               repeat=False)
# アニメーションを保存する場合は次のようにする
anim.save("animation3.mp4")
plt.show()
