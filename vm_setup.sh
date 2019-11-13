# clone repo and install the conda env 
git clone https://www.github.com/microsoft/computervision 
# change permission as we copy this into each user's folder
chmod -R ugo+rwx /root/computervision
cd computervision 
conda env create -f environment.yml --name cv
conda activate cv 
python -m ipykernel install --name cv --display-name "MLADS CV LAB" 

# add the 5 users to jupyterhub
echo 'c.Authenticator.whitelist = {"mlads0", "mlads1", "mlads2", "mlads3", "mlads4"}' | sudo tee -a /etc/jupyterhub/jupyterhub_config.py

# create the users to the vm 
for i in {1..5}
do
    USERNAME=mlads$i
    PASSWORD=cvmlads$i
    sudo adduser --quiet --disabled-password --gecos "" $USERNAME
    echo "$USERNAME:$PASSWORD" | sudo chpasswd
    rm -rf /data/home/$USERNAME/notebooks/*
    # copy repo
    cp -ar /root/computervision /data/home/$USERNAME/notebooks
done

# restart jupyterhub 
sudo systemctl stop jupyterhub 
sudo systemctl start jupyterhub 

exit
