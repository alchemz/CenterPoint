# train set 
export EQUITY_ROOT=$1
export WAYMO_DATASET_ROOT=$2

## Convert train
mkdir -p $WAYMO_DATASET_ROOT'/train_pickle/'

# avoid using gpu
CUDA_VISIBLE_DEVICES=-1 python $EQUITY_ROOT/CenterPoint/det3d/datasets/waymo/waymo_converter.py \
--record_path $WAYMO_DATASET_ROOT'/training/*.tfrecord'  \
--root_path $WAYMO_DATASET_ROOT'/train_pickle/'

## Convert val
mkdir -p $WAYMO_DATASET_ROOT'/val_pickle/'

# validation set, avoid using gpu 
CUDA_VISIBLE_DEVICES=-1 python $EQUITY_ROOT/CenterPoint/det3d/datasets/waymo/waymo_converter.py \
--record_path $WAYMO_DATASET_ROOT'/validation/*.tfrecord' \
--root_path $WAYMO_DATASET_ROOT'/val_pickle/'

# Convert test
mkdir -p $WAYMO_DATASET_ROOT'/test_pickle/'

# testing set, avoid using gpu
CUDA_VISIBLE_DEVICES=-1 python $EQUITY_ROOT/CenterPoint/det3d/datasets/waymo/waymo_converter.py \
--record_path $WAYMO_DATASET_ROOT'/testing/*.tfrecord'  \
--root_path $WAYMO_DATASET_ROOT'/test_pickle/'
