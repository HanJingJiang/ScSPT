clear
clc
load('Data');
RD=LD;
RS=gene;
DS=cell;

Adj=[RS,RD;RD',DS];
for k=1:1                                                    
    AdjTraining=Adj;
    N=length(Adj);
    probMatrix=zeros(N,N);
%Set the size of perturbations and number of independent perturbations
    pertuSize=ceil(0.1*(length(find(AdjTraining~= 0)))/2);
    %计算每次扰动的大小，取训练网络中非零元素的 10% 作为扰动的大小
    perturbations=10;
    %定义进行扰动的次数
    for pertus=1:perturbations
        AdjUnpertu=AdjTraining;% 复制训练网络到 AdjUnpertu
        index=find(tril(AdjTraining));
        [i,j]=ind2sub(size(tril(AdjTraining)),index);
         % 获取下三角部分非零元素的行和列索引
        for pp=1:pertuSize
            % 开始单次扰动的循环
            rand_num=ceil(length(i)*rand(1));
            % 生成一个随机数，用于从可用的索引中选择
            select_ID1=i(rand_num);
            select_ID2=j(rand_num);
            i(rand_num)=[];
            j(rand_num)=[];
             % 选择要扰动的位置的行和列索引，并从可用的索引中删除已选择的位置
            AdjUnpertu(select_ID1,select_ID2)=0;
            AdjUnpertu(select_ID2,select_ID1)=0;
            % 在选择的位置上将网络扰动置零
        end
        AdjUnpertu = full(AdjUnpertu);
        % 将扰动后的网络转换为完整格式
        probMatrix=probMatrix+perturbation(AdjUnpertu,AdjTraining);
    end
 % 将累积的扰动矩阵除以扰动的次数，得到平均扰动效果
probMatrix= probMatrix/10;
k=length(cell);
subMatrix = probMatrix(1:2000, 2001:2000+k);
save('SPM',"subMatrix")

end
