import subprocess
import sys
import pkg_resources

# 要检查的包列表
required_packages = [
    "pandas",
    "openpyxl",
    "argparse"
]

def install_package(pkg):
    """安装缺失的包"""
    subprocess.check_call([sys.executable, "-m", "pip", "install", pkg])

def check_and_install(packages):
    """检查并安装缺失的包"""
    installed = {pkg.key for pkg in pkg_resources.working_set}
    missing = [pkg for pkg in packages if pkg not in installed]
    
    if missing:
        print(f"缺失的包: {', '.join(missing)}")
        for pkg in missing:
            print(f"正在安装 {pkg}...")
            install_package(pkg)
    else:
        print("所有包都已安装!")

if __name__ == "__main__":
    check_and_install(required_packages)
