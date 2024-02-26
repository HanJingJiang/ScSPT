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
    %����ÿ���Ŷ��Ĵ�С��ȡѵ�������з���Ԫ�ص� 10% ��Ϊ�Ŷ��Ĵ�С
    perturbations=10;
    %��������Ŷ��Ĵ���
    for pertus=1:perturbations
        AdjUnpertu=AdjTraining;% ����ѵ�����絽 AdjUnpertu
        index=find(tril(AdjTraining));
        [i,j]=ind2sub(size(tril(AdjTraining)),index);
         % ��ȡ�����ǲ��ַ���Ԫ�ص��к�������
        for pp=1:pertuSize
            % ��ʼ�����Ŷ���ѭ��
            rand_num=ceil(length(i)*rand(1));
            % ����һ������������ڴӿ��õ�������ѡ��
            select_ID1=i(rand_num);
            select_ID2=j(rand_num);
            i(rand_num)=[];
            j(rand_num)=[];
             % ѡ��Ҫ�Ŷ���λ�õ��к������������ӿ��õ�������ɾ����ѡ���λ��
            AdjUnpertu(select_ID1,select_ID2)=0;
            AdjUnpertu(select_ID2,select_ID1)=0;
            % ��ѡ���λ���Ͻ������Ŷ�����
        end
        AdjUnpertu = full(AdjUnpertu);
        % ���Ŷ��������ת��Ϊ������ʽ
        probMatrix=probMatrix+perturbation(AdjUnpertu,AdjTraining);
    end
 % ���ۻ����Ŷ���������Ŷ��Ĵ������õ�ƽ���Ŷ�Ч��
probMatrix= probMatrix/10;
k=length(cell);
subMatrix = probMatrix(1:2000, 2001:2000+k);
save('SPM',"subMatrix")

end
